LOCAL_PATH := device/samsung/a12s

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery \
    fastbootd

# Props
PRODUCT_PROPERTY_OVERRIDES +=\
    ro.boot.dynamic_partitions=true

#PRODUCT_PACKAGES += \
#    resetprop \
#    libresetprop
