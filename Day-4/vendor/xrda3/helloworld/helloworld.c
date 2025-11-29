#include <stdio.h>
#define LOG_TAG "helloworld"
#include <log/log.h>

int main (void)
{
	printf("Hello, world!\n");
	ALOGE("Hello, world!");
	return 0;
}
