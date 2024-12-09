#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/mod_devicetable.h>
#include <linux/io.h>
#include <linux/mutex.h>       
#include <linux/miscdevice.h>  
#include <linux/types.h>       
#include <linux/fs.h> 
#include <linux/kstrtox.h>           

#define HPS_LED_CONTROL_OFFSET  0x0
#define BASE_PERIOD_OFFSET      0x04
#define LED_REG_OFFSET          0x08

#define SPAN 			0x10

/*
*	STATE CONTAINTER
*/
struct led_patterns_dev {
    void __iomem *base_addr;
    void __iomem *hps_led_control;
    void __iomem *base_period;
    void __iomem *led_reg;
    struct miscdevice miscdev;
    struct mutex lock; 
};
/*
*	FUNCTIONS
*/
static ssize_t hps_led_control_show(struct device *dev,
                                    struct device_attribute *attr, char *buf)
{
    bool hps_control;
    struct led_patterns_dev *priv = dev_get_drvdata(dev);

    hps_control = ioread32(priv->hps_led_control);

    return scnprintf(buf, PAGE_SIZE, "%u\n", hps_control);
}

static ssize_t hps_led_control_store(struct device *dev,
                                     struct device_attribute *attr,
                                     const char *buf, size_t size)
{
    bool hps_control;
    int ret;
    struct led_patterns_dev *priv = dev_get_drvdata(dev);

    ret = kstrtobool(buf, &hps_control);
    if (ret < 0) 
    {
        return ret;
    }

    iowrite32(hps_control, priv->hps_led_control);

    return size;
}

static ssize_t led_patterns_read(struct file *file, char __user *buf,
                                 size_t count, loff_t *offset)
{
    size_t ret;
    u32 val;

    struct led_patterns_dev *priv = container_of(file->private_data,
                                                 struct led_patterns_dev, miscdev);

    if (*offset < 0) 
    {
        return -EINVAL;
    }
    if (*offset >= SPAN) 
    {
        return 0;
    }
    if ((*offset % 0x4) != 0) 
    {
        pr_warn("led_patterns_read: unaligned access\n");
        return -EFAULT;
    }

    val = ioread32(priv->base_addr + *offset);

    ret = copy_to_user(buf, &val, sizeof(val));
    if (ret == sizeof(val)) {
        pr_warn("led_patterns_read: nothing copied\n");
        return -EFAULT;
    }

    *offset += sizeof(val);

    return sizeof(val);
}

static ssize_t led_patterns_write(struct file *file, const char __user *buf,
                                  size_t count, loff_t *offset)
{
    size_t ret;
    u32 val;

    struct led_patterns_dev *priv = container_of(file->private_data,
                                                 struct led_patterns_dev, miscdev);

    if (*offset < 0) 
    {
        return -EINVAL;
    }
    if (*offset >= SPAN) 
    {
        return 0;
    }
    if ((*offset % 0x4) != 0) 
    {
        pr_warn("led_patterns_write: unaligned access\n");
        return -EFAULT;
    }

    mutex_lock(&priv->lock);

    ret = copy_from_user(&val, buf, sizeof(val));
    if (ret != sizeof(val)) 
    {
        iowrite32(val, priv->base_addr + *offset);
        *offset += sizeof(val);
        ret = sizeof(val);
    } 
    else 
    {
        pr_warn("led_patterns_write: nothing copied from user space\n");
        ret = -EFAULT;
    }

    mutex_unlock(&priv->lock);
    return ret;
}

static ssize_t led_reg_show(struct device *dev,
                            struct device_attribute *attr, char *buf)
{
    u8 led_reg;
    struct led_patterns_dev *priv = dev_get_drvdata(dev);

    led_reg = ioread32(priv->led_reg);

    return scnprintf(buf, PAGE_SIZE, "%u\n", led_reg);
}

static ssize_t led_reg_store(struct device *dev,
                             struct device_attribute *attr,
                             const char *buf, size_t size)
{
    u8 led_reg;
    int ret;
    struct led_patterns_dev *priv = dev_get_drvdata(dev);

    ret = kstrtou8(buf, 0, &led_reg);
    if (ret < 0) 
    {
        return ret;
    }

    iowrite32(led_reg, priv->led_reg);

    return size;
}

static ssize_t base_period_show(struct device *dev,
                                struct device_attribute *attr, char *buf)
{
    u8 base_period;
    struct led_patterns_dev *priv = dev_get_drvdata(dev);

    base_period = ioread32(priv->base_period);

    return scnprintf(buf, PAGE_SIZE, "%u\n", base_period);
}

static ssize_t base_period_store(struct device *dev,
                                 struct device_attribute *attr,
                                 const char *buf, size_t size)
{
    u8 base_period;
    int ret;
    struct led_patterns_dev *priv = dev_get_drvdata(dev);

    ret = kstrtou8(buf, 0, &base_period);
    if (ret < 0) 
    {
        return ret;
    }

    iowrite32(base_period, priv->base_period);

    return size;
}
/*
*	SYSFS ATTRIBUTES
*/
static DEVICE_ATTR_RW(hps_led_control);
static DEVICE_ATTR_RW(base_period);
static DEVICE_ATTR_RW(led_reg);

static struct attribute *led_patterns_attrs[] = {
    &dev_attr_hps_led_control.attr,
    &dev_attr_base_period.attr,
    &dev_attr_led_reg.attr,
    NULL,
};
ATTRIBUTE_GROUPS(led_patterns);

/*
*	FILE OPERATIONS
*/ 
static const struct file_operations led_patterns_fops = {
    .owner = THIS_MODULE,
    .read = led_patterns_read,
    .write = led_patterns_write,
    .llseek = default_llseek,
};
/*
*	PROBE FUNCTION
*/
static int led_patterns_probe(struct platform_device *pdev)
{
    struct led_patterns_dev *priv;
    size_t ret;
    

    priv = devm_kzalloc(&pdev->dev, sizeof(struct led_patterns_dev), 
    			GFP_KERNEL);
    if (!priv) 
    {
        pr_err("Failed to allocate memory\n");
        return -ENOMEM;
    }

    priv->base_addr = devm_platform_ioremap_resource(pdev, 0);
    if (IS_ERR(priv->base_addr)) 
    {
        pr_err("Failed to request/remap platform device resource\n");
        return PTR_ERR(priv->base_addr);
    }

    priv->hps_led_control = priv->base_addr + HPS_LED_CONTROL_OFFSET;
    priv->base_period = priv->base_addr + BASE_PERIOD_OFFSET;
    priv->led_reg = priv->base_addr + LED_REG_OFFSET;

    iowrite32(1, priv->hps_led_control);
    iowrite32(0xff, priv->led_reg);
    
    priv->miscdev.minor = MISC_DYNAMIC_MINOR;
    priv->miscdev.name = "led_patterns";
    priv->miscdev.fops = &led_patterns_fops;
    priv->miscdev.parent = &pdev->dev;
    
    ret = misc_register(&priv->miscdev);
    if (ret) 
    {
    	pr_err("Failed to register misc device");
    	return ret;
    }

    platform_set_drvdata(pdev, priv);

    pr_info("led_patterns_probe successful\n");
    return 0;
}
/*
*	REMOVE FUNCTION
*/
static int led_patterns_remove(struct platform_device *pdev)
{
    struct led_patterns_dev *priv = platform_get_drvdata(pdev);

    iowrite32(0, priv->hps_led_control);
    misc_deregister(&priv->miscdev);

    pr_info("led_patterns_remove successful\n");
    
    return 0;
}
/*
*	PLATFORM DRIVER
*/
static const struct of_device_id led_patterns_of_match[] = {
    { .compatible = "hexom,led_patterns", },
    { }
};
MODULE_DEVICE_TABLE(of, led_patterns_of_match);

static struct platform_driver led_patterns_driver = {
    .probe = led_patterns_probe,
    .remove = led_patterns_remove,
    .driver = {
        .owner = THIS_MODULE,
        .name = "led_patterns",
        .of_match_table = led_patterns_of_match,
        .dev_groups = led_patterns_groups, 
    },
};
/*
*	REGISTER
*/
module_platform_driver(led_patterns_driver);

MODULE_LICENSE("Dual MIT/GPL");
MODULE_AUTHOR("Jordy Hexom");
MODULE_DESCRIPTION("LED patterns platform driver");
