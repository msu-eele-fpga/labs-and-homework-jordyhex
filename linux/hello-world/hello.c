// SPDX-License-Identifier: GPL-2.0
/*
 * Hello World Kernel Module
 * @Author: Jordy Hexom
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Jordy Hexom");
MODULE_DESCRIPTION("Hello World Kernel Module.");
MODULE_VERSION("1.0");

static int __init hello_init(void)
{
    printk(KERN_INFO "Hello, world\n");
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Goodbye, cruel world\n");
}

module_init(hello_init);
module_exit(hello_exit);