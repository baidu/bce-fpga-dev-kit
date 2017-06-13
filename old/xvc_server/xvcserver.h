/*********************************************************************
 * Copyright (c) 2015 Xilinx, Inc.  All rights reserved.
 *
 *                 XILINX CONFIDENTIAL PROPERTY
 * This   document  contains  proprietary information  which   is
 * protected by  copyright. All rights  are reserved. No  part of
 * this  document may be photocopied, reproduced or translated to
 * another  program  language  without  prior written  consent of
 * XILINX Inc., San Jose, CA. 95124
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 **********************************************************************/

/*
 * XVC server interface
 *
 * This interface can be used to implement XVC server using this
 * reusable XVC protocol implementation.
 *
 * To start the XVC server an implementation should call the
 * xvcserver_start() function.
 */

#ifdef __cplusplus
extern "C" {
#endif

typedef struct XvcClient XvcClient;

/*
 * XVC server callback function table.
 */
typedef struct XvcServerHandlers {
    /* Called when a connection is established to allow the
     * implementation to initialize the virtual cable and save the
     * XvcClient pointer needed to report errors. */
    int (*open_port)(
        void * client_data,
        XvcClient * c);

    /* Called when a connection is closed to allow the implementation
     * to close the virtual cable. */
    void (*close_port)(
        void * client_data);

    /* Called when the settck: command is received to update the clock
     * period of the scan chain. */
    void (*set_tck)(
        void * client_data,
        unsigned long nsperiod,
        unsigned long * result);

    /* Called when the shift: command is received to perform <count>
     * TCK.  <tms_buf> and <tdi_buf> contain TMS and TDI values for
     * each clock.  <tdo_buf> should be populated for each clock from
     * TDO.  This callback may defer populating <tdo_buf> until flush()
     * or unlock() callback is called. */
    void (*shift_tms_tdi)(
        void * client_data,
        unsigned long count,
        unsigned char * tms_buf,
        unsigned char * tdi_buf,
        unsigned char * tdo_buf);

    /* Called when the lock: command is received to lock the scan
     * chain and prevent sources other than the xvcserver to perform
     * scan chain operations until the next unlock() callback.  If the
     * lock cannot be acquired within <timeout> seconds then the error
     * "TIMEOUT" should be generated using the xvcserver_set_error()
     * function.  This callback is optional and must be set to NULL
     * when not implemented. */
    void (*lock)(
        void * client_data,
        unsigned timeout);

    /* Called when the unlock: command is received to unlock the scan
     * chain and allow other sources to perform scan chain operations.
     * This callback is optional and must be set to NULL when not
     * implemented. */
    void (*unlock)(
        void * client_data);

    /* Called when the irshift: or drshift: command is received to
     * shift <count> instruction or data bits and then transition the
     * JTAG state machine in <state>.  <flags> controls if <tdo_buf>
     * needs to be populated and if TDI data comes from <tdi_buf> or
     * is all zeros or ones.  This callback is optional and must be
     * set to NULL when not implemented.  This callback may defer
     * populating tdo_buf until flush() or unlock() callback is
     * called. */
    void (*register_shift)(
        void * client_data,
        int instruction,
        unsigned flags,
        unsigned state,
        unsigned long count,
        unsigned char * tdi_buf,
        unsigned char * tdo_buf);

    /* Called when the state: command is received to transition the
     * JTAG state machine to <state> and then issue <count>
     * clocks. While issuing <count> clocks the value of TMS should be
     * the same value that was used to enter the current state except
     * when the current state is one of the CAPTURE states.  This rule
     * cause the state machine to stay in looping when that is the
     * starting state and otherwise move the shortest distance towards
     * TEST-LOGIC-RESET.  This callback is optional and must be set to
     * NULL when not implemented. */
    void (*state)(
        void * client_data,
        unsigned flags,
        unsigned state,
        unsigned long count);

    /* Called to notify the implementation that the effect of any
     * pending commands must be completed.  This callback is optional
     * and must be set to NULL when not implemented. */
    int (*flush)(
        void * client_data);
} XvcServerHandlers;

/*
 * This function can be used by callback functions to report errors.
 */
void xvcserver_set_error(
    XvcClient * c,
    const char * fmt, ...);

/*
 * Start XVC server listing for incomming connections on <url>.  This
 * function will wait indefinitely for incomming connections.  When a
 * connection is established this function will initiate callback
 * functions defined in <handlers>.  Each callback will be passed the
 * <client_data> argument given to this function in addition to other
 * callback specific arguments.
 */
int xvcserver_start(
    const char * url,
    void * client_data,
    XvcServerHandlers * handlers);

#ifdef __cplusplus
}
#endif
