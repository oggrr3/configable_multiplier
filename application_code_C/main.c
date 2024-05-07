/*
 * main.c
 *
 *  Created on: Apr 25, 2024
 *      Author: caovi
 */

#include <stdio.h>
//#include "xparameters.h"
#include "xil_types.h"
#include "xstatus.h"
//#include "xil_testmem.h"

#include "platform.h"
#include "memory_config.h"
#include "xil_printf.h"

#include "xil_io.h"
#include "sleep.h"

#include "my_multiplication.h"

int main() {

    init_platform();

	long long int result;
	int number1 = -31;
	int number2 = 123;

	print("My multiply application test starting\n\r");
	enable_reset();
	sleep(1);
	disable_reset();
	put_two_number(number1, number2);
	enable_to_multiply(2);
	check_data_valid();
	result = get_result();
	printf("%d x %d = %lld", number1, number2, result);

	print("My multiply application test complete\n\r");
	
	cleanup_platform();
    return 0;
}

