#include <linux/init.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Lorenzo Stoakes <lstoakes@gmail.com>");
MODULE_DESCRIPTION("A test module that outputs hello world.");

static int __init
hello_init(void)
{
	pr_debug("Hello World!\n");

	return 0;
}

static void __exit
hello_exit(void)
{
	/* Nothing to do :) */
}

module_init(hello_init);
module_exit(hello_exit);
