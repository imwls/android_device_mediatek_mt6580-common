LOCAL_PATH := $(call my-dir)

ifneq ($(sombrero, kw88, osiris,$(TARGET_DEVICE)),)

include $(call all-makefiles-under,$(LOCAL_PATH))

endif
