$(call inherit-product, vendor/mediatek/mt6580-common/copyfiles.mk)
$(call inherit-product, vendor/mediatek/mt6580-common/mt6580-common-vendor.mk)

LOCAL_PATH := device/mediatek/mt6580-common

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := hdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Manifest
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/etc/manifest.xml:system/vendor/manifest.xml

# Audio
PRODUCT_PACKAGES += \
    audio_policy.default \
    audio_policy.stub \
    audio.a2dp.default \
    audio.r_submix.default \
    audio.usb.default \
    libaudio-resampler \
    tinymix \
    libtinyalsa \
    libtinycompress \
    libtinymix \
    libtinyxml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_device.xml:system/vendor/etc/audio_device.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy.conf:system/vendor/etc/audio_policy.conf \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:system/vendor/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/vendor/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:system/vendor/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:system/vendor/etc/default_volume_tables.xml

# Watchface Launcher
PRODUCT_PACKAGES += \
    ClockSkinCoco

# Bluetooth
PRODUCT_PACKAGES += \
    libbt-vendor

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/bluetooth/auto_pair_devlist.conf:system/etc/bluetooth/auto_pair_devlist.conf \
    $(LOCAL_PATH)/configs/bluetooth/bt_did.conf:system/etc/bluetooth/bt_did.conf

ifeq ($(TARGET_BUILD_VARIANT), eng)
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/configs/bluetooth/bt_stack.conf.debug:system/etc/bluetooth/bt_stack.conf
else
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/configs/bluetooth/bt_stack.conf:system/etc/bluetooth/bt_stack.conf
endif

# Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/fstab.mt6580:root/fstab.mt6580 \
    $(LOCAL_PATH)/rootdir/init.mt6580.rc:root/init.mt6580.rc \
    $(LOCAL_PATH)/rootdir/init.mt6580.usb.rc:root/init.mt6580.usb.rc \
    $(LOCAL_PATH)/rootdir/init.nvdata.rc:root/init.nvdata.rc \
    $(LOCAL_PATH)/rootdir/ueventd.mt6580.rc:root/ueventd.mt6580.rc

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal/.ht120.mtc:system/vendor/etc/.tp/.ht120.mtc \
    $(LOCAL_PATH)/configs/thermal/thermal.conf:system/vendor/etc/.tp/thermal.conf \
    $(LOCAL_PATH)/configs/thermal/thermal.off.conf:system/vendor/etc/.tp/thermal.off.conf \
    $(LOCAL_PATH)/configs/thermal/.thermal_policy_00:system/vendor/etc/.tp/.thermal_policy_00

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/vendor/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/vendor/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/vendor/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/vendor/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/vendor/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/vendor/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/vendor/etc/permissions/android.hardware.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/vendor/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/vendor/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/vendor/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/vendor/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/vendor/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/vendor/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/vendor/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/vendor/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:system/vendor/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/vendor/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/vendor/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/vendor/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/vendor/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/vendor/etc/permissions/android.hardware.usb.host.xml

# Media
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/vendor/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/vendor/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:system/vendor/etc/media_codecs_google_video_le.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_codecs.xml:system/vendor/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_mediatek_video.xml:system/vendor/etc/media_codecs_mediatek_video.xml \
    $(LOCAL_PATH)/configs/media/media_profiles.xml:system/vendor/etc/media_profiles.xml

# Wifi
PRODUCT_PACKAGES += \
    lib_driver_cmd_mt66xx \
    libwifi-hal-mt66xx \
    wifi_hal \
    libwpa_client \
    hostapd \
    hostapd_cli \
    dhcpcd.conf \
    wpa_supplicant \
    wpa_supplicant.conf \
    android.hardware.wifi@1.0-service \
    wificond \
    wifilogd

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/hostapd/hostapd_default.conf:system/vendor/etc/hostapd/hostapd_default.conf \
    $(LOCAL_PATH)/configs/hostapd/hostapd.accept:system/vendor/etc/hostapd/hostapd.accept \
    $(LOCAL_PATH)/configs/hostapd/hostapd.deny:system/vendor/etc/hostapd/hostapd.deny \
    $(LOCAL_PATH)/configs/etc/wifi/wpa_supplicant.conf:system/vendor/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/configs/etc/wifi/wpa_supplicant_overlay.conf:system/vendor/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/etc/wifi/p2p_supplicant_overlay.conf:system/vendor/etc/wifi/p2p_supplicant_overlay.conf

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.mount.fs=EXT4

PRODUCT_PROPERTY_OVERRIDES += \
    persist.debug.wfd.enable=1

# Lights
PRODUCT_PACKAGES += \
    lights.mt6580

# Sensor Wrapper
PRODUCT_PACKAGES += \
    sensors.mt6580

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Low Ram
PRODUCT_PROPERTY_OVERRIDES += ro.config.low_ram=true

# Dalvik
$(call inherit-product, frameworks/native/build/phone-hdpi-512-dalvik-heap.mk)

PRODUCT_TAGS += dalvik.gc.type-precise

# Shims
PRODUCT_PACKAGES += \
    libmtkshim_log \
    libmtkshim_audio \
    libmtkshim_ui \
    libmtkshim_gui \
    libmtkshim_omx

# Display
PRODUCT_PACKAGES += \
    libion

# Gralloc
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.renderscript@1.0-impl

# HW Composer
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl

# Light HAL
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-impl

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl

# Memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl

# PowerHAL
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl

# VibratorHAL
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service

# UsbHAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# USB
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.soundtrigger@2.0-impl

# SELinux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Google properties overides
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    net.tethering.noprovisioning=true \
    ro.setupwizard.rotation_locked=true