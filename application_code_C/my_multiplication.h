/*
 * mulitiplication.h
 *
 *  Created on: Apr 25, 2024
 *      Author: caovi
 */

#ifndef SRC_MULITIPLICATION_H_
#define SRC_MULITIPLICATION_H_

#include "xil_io.h"
#include "xil_types.h"
#include "xparameters.h"

void enable_reset() {
	Xil_Out32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR, 0x00);
}

void disable_reset() {
	Xil_Out32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR, 0x01);
}

void enable_to_multiply(int choose_mode) {
	if (choose_mode == 0)
		Xil_Out32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR, 0x03);	// 8 bit single
	else if (choose_mode == 1)
		Xil_Out32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR, 0x07);	// 8 bit //
	else
		Xil_Out32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR, 0x0b);	// 16 bit single
}

void put_two_number(int number1, int number2) {
	Xil_Out32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR + 4, (number1<<16) + number2);
}

long long int get_result() {
	return Xil_In32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR + 8);

}

void check_data_valid() {
	while (Xil_In32(XPAR_MULTIPLICATION_IP_CO_0_S00_AXI_BASEADDR + 12) != 1);
}

#endif /* SRC_MULITIPLICATION_H_ */
