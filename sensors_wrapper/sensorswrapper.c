/*
 * Copyright (c) 2017 The LineageOS Project
 * Copyright (C) 2017 Martin Bouchet.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *	  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "sensors_hal_wrapper"
//#define LOG_NDEBUG 0

#include <errno.h>
#include <cutils/log.h>

#include <hardware/hardware.h>
#include <hardware/sensors.h>

static pthread_mutex_t init_sensors_mutex = PTHREAD_MUTEX_INITIALIZER;

static struct sensors_module_t *gVendorModule = 0;
static struct sensors_poll_device_1 *mtk_hw_dev = NULL;
static struct sensor_t const* global_sensors_list = NULL;
static int global_sensors_count = -1;

#define WRAP_HAL(name, rettype, prototype, parameters) \
	static rettype wrapper_ ## name  prototype { \
		return mtk_hw_dev->name parameters; \
	}

static int check_vendor_module() {
	int ret = 0;

	if (gVendorModule)
		return 0;

	ret = hw_get_module_by_class("sensors", "vendor", (const hw_module_t **)&gVendorModule);
	if (ret)
		ALOGE("failed to open vendor sensors module");
	return ret;
}

/*
 * Lazy-initializes global_sensors_count, global_sensors_list.
 */
static void lazy_init_sensors_list() {
    pthread_mutex_lock(&init_sensors_mutex);
    if (global_sensors_list != NULL) {
        // already initialized
        pthread_mutex_unlock(&init_sensors_mutex);
        return;
    }

	if (check_vendor_module())
		return;

    // Count all the sensors, then allocate an array of blanks.
    global_sensors_count = 0;
    const struct sensor_t *subhal_sensors_list;
    global_sensors_count += gVendorModule->get_sensors_list(gVendorModule, &subhal_sensors_list);

    // Fix the fields of the sensor to be compliant with the API version reported by the wrapper.
    for (int i = 0; i < global_sensors_count; i++) {
        // Becasue batching and flushing don't work modify the sensor fields to not report any fifo counts.
        subhal_sensors_list[i].fifoReservedEventCount = 0;
        subhal_sensors_list[i].fifoMaxEventCount = 0;

        switch (subhal_sensors_list[i].type) {
        // Use the flags suggested by the sensors documentation.
        case SENSOR_TYPE_TILT_DETECTOR:
            subhal_sensors_list[i].flags = SENSOR_FLAG_WAKE_UP | SENSOR_FLAG_ON_CHANGE_MODE;
            break;

        case SENSOR_TYPE_HEART_RATE:
            subhal_sensors_list[i].requiredPermission = SENSOR_PERMISSION_BODY_SENSORS;
            break;
        
        // Report a proper range to fix doze proximity check.
        case SENSOR_TYPE_PROXIMITY:
            subhal_sensors_list[i].maxRange = 5.0;
            break;
        }
    }
    // Copy the HAL's modified sensor list into global_sensors_list,
    global_sensors_list = subhal_sensors_list;
    pthread_mutex_unlock(&init_sensors_mutex);
}

int sensors_list_get(struct sensors_module_t* module, struct sensor_t const** plist) {
    lazy_init_sensors_list();
    if (global_sensors_list != NULL) {
        *plist = global_sensors_list;
        return global_sensors_count;
    } else {
        return -EINVAL;
    }
}

WRAP_HAL(setDelay, int, (struct sensors_poll_device_t *dev, int handle, int64_t ns), (mtk_hw_dev, handle, ns))
WRAP_HAL(activate, int, (struct sensors_poll_device_t *dev, int handle, int enabled), (mtk_hw_dev, handle, enabled))
WRAP_HAL(poll, int, (struct sensors_poll_device_t *dev, sensors_event_t* data, int count), (mtk_hw_dev, data, count))

static int wrapper_batch(struct sensors_poll_device_1 *dev,
					int handle, int flags, int64_t ns, int64_t timeout) {
	return mtk_hw_dev->setDelay(mtk_hw_dev, handle, ns);
}

static int wrapper_flush(struct sensors_poll_device_1 *dev, int handle) {
	return -EINVAL;
}

static int wrapper_sensors_module_close(struct hw_device_t* device) {
	int ret;

	if (!device) {
		ret = -EINVAL;
	}

	ret = mtk_hw_dev->common.close(device);
	
    free(mtk_hw_dev);
    mtk_hw_dev = NULL;
    if (global_sensors_list) {
        free(global_sensors_list);
        global_sensors_list = NULL;
    }

	return ret;
}

static int sensors_module_open(const struct hw_module_t* module, const char* id, struct hw_device_t** device) {
	int ret=0;
	struct sensors_poll_device_1 *dev;

	ALOGI("Initializing wrapper for MTK Sensor-HAL");
	if (mtk_hw_dev) {
		ALOGE("Sensor HAL already opened!");
		ret = -ENODEV;
		goto fail;
	}
	
	ret = check_vendor_module();

	if (ret) {
		ALOGE("%s couldn't open sensors module in %s. (%s)", __func__,
				 SENSORS_HARDWARE_MODULE_ID, strerror(-ret));
		goto fail;
	}

	ret = gVendorModule->common.methods->open((const hw_module_t*)gVendorModule, id, (hw_device_t**)&mtk_hw_dev);
	
	if (ret) {
		ALOGE("%s couldn't open sensors module in %s. (%s)", __func__,
				 SENSORS_HARDWARE_MODULE_ID, strerror(-ret));
		goto fail;
	}

	*device = malloc(sizeof(struct sensors_poll_device_1));

	if (!*device) {
		ALOGE("Can't allocate memory for device, aborting...");
		ret = -ENOMEM;
		goto fail;
	}

	memset(*device, 0, sizeof(struct sensors_poll_device_1));
	dev = (struct sensors_poll_device_1*)*device;

	dev->common.tag = HARDWARE_DEVICE_TAG;
	dev->common.version = SENSORS_DEVICE_API_VERSION_1_3;
	dev->common.module = (struct hw_module_t*)module;

	dev->common.close = wrapper_sensors_module_close;
	dev->activate = wrapper_activate;
	dev->setDelay = wrapper_setDelay;
	dev->poll = wrapper_poll;
	dev->batch = wrapper_batch;
	dev->flush = wrapper_flush;

	return ret;
	
	fail:
	if (mtk_hw_dev) {
		free(mtk_hw_dev);
		mtk_hw_dev = NULL;
	}
	if (dev) {
		free(dev);
		dev = NULL;
	}
    if (global_sensors_list) {
        free(global_sensors_list);
        global_sensors_list = NULL;
    }
	*device = NULL;
	return ret;
}

struct hw_module_methods_t sensors_module_methods = {
	open: sensors_module_open
};

struct sensors_module_t HAL_MODULE_INFO_SYM = {
	common: {
		tag: HARDWARE_MODULE_TAG,
		version_major: 1,
		version_minor: 0,
		id: SENSORS_HARDWARE_MODULE_ID,
		name : "Samsung Sensors HAL Wrapper",
		author : "Martin Bouchet (tincho5588@gmail.com)",
		methods: &sensors_module_methods,
	},
	get_sensors_list: sensors_list_get
};
