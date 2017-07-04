; ModuleID = '/home/ruanyuan/CLOUD/fpga_cloud/hls/vectoradd/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@memcpy_OC_buff_b_OC_s = internal unnamed_addr constant [23 x i8] c"memcpy.buff_b.addr.a.V\00"
@memcpy_OC_buff_a_OC_s = internal unnamed_addr constant [23 x i8] c"memcpy.buff_a.addr.a.V\00"
@memcpy_OC_a_OC_V_OC_s = internal unnamed_addr constant [23 x i8] c"memcpy.a.V.buff.V.addr\00"
@llvm_global_ctors_1 = appending global [1 x void ()*] [void ()* @_GLOBAL__I_a]
@llvm_global_ctors_0 = appending global [1 x i32] [i32 65535]
@example_str = internal unnamed_addr constant [8 x i8] c"example\00"
@burstwrite_OC_region = internal unnamed_addr constant [18 x i8] c"burstwrite.region\00"
@burstread_OC_region_s = internal unnamed_addr constant [17 x i8] c"burstread.region\00"
@p_str3 = private unnamed_addr constant [11 x i8] c"for_loop_N\00", align 1
@p_str2 = private unnamed_addr constant [6 x i8] c"m_axi\00", align 1
@p_str12 = internal unnamed_addr constant [1 x i8] zeroinitializer
@p_str11 = internal unnamed_addr constant [1 x i8] zeroinitializer
@p_str10 = internal unnamed_addr constant [1 x i8] zeroinitializer
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str = private unnamed_addr constant [7 x i8] c"ap_vld\00", align 1

declare i256 @llvm.part.select.i256(i256, i32, i32) nounwind readnone

declare i16 @llvm.part.select.i16(i16, i32, i32) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

define void @example(i256* %a_V, i16 %n_V, i32 %a_addr, i32 %b_addr, i32 %c_addr) {
arrayctor.loop1.preheader:
  call void (...)* @_ssdm_op_SpecBitsMap(i256* %a_V), !map !114
  call void (...)* @_ssdm_op_SpecBitsMap(i16 %n_V), !map !120
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %a_addr), !map !126
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %b_addr), !map !130
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %c_addr), !map !134
  call void (...)* @_ssdm_op_SpecTopModule([8 x i8]* @example_str) nounwind
  %c_addr_read = call i32 @_ssdm_op_Read.ap_vld.i32(i32 %c_addr)
  %b_addr_read = call i32 @_ssdm_op_Read.ap_vld.i32(i32 %b_addr)
  %a_addr_read = call i32 @_ssdm_op_Read.ap_vld.i32(i32 %a_addr)
  %n_V_read = call i16 @_ssdm_op_Read.ap_vld.i16(i16 %n_V)
  %buff_a = alloca [256 x i256], align 8
  %buff_b = alloca [256 x i256], align 8
  %buff_V = alloca [256 x i256], align 8
  call void (...)* @_ssdm_op_SpecInterface(i32 %a_addr, [7 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 %b_addr, [7 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 %c_addr, [7 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i16 %n_V, [7 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i256* %a_V, [6 x i8]* @p_str2, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 512, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 16, i32 16, i32 16, i32 16, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  %tmp = call i8 @_ssdm_op_PartSelect.i8.i16.i32.i32(i16 %n_V_read, i32 8, i32 15)
  %tmp_cast = zext i8 %tmp to i9
  %r_V = trunc i16 %n_V_read to i8
  %r_V_cast = zext i8 %r_V to i9
  %i_op_assign = icmp ne i8 %r_V, 0
  %tmp_2_cast = zext i1 %i_op_assign to i9
  %segment_V = add i9 %tmp_2_cast, %tmp_cast
  %r_V_1 = add i9 -1, %segment_V
  br label %0

; <label>:0                                       ; preds = %memcpy.tail, %arrayctor.loop1.preheader
  %s = phi i9 [ 0, %arrayctor.loop1.preheader ], [ %s_1, %memcpy.tail ]
  %curr_addr_a = phi i32 [ %a_addr_read, %arrayctor.loop1.preheader ], [ %curr_addr_a_1, %memcpy.tail ]
  %curr_addr_b = phi i32 [ %b_addr_read, %arrayctor.loop1.preheader ], [ %curr_addr_b_1, %memcpy.tail ]
  %curr_addr_c = phi i32 [ %c_addr_read, %arrayctor.loop1.preheader ], [ %curr_addr_c_1, %memcpy.tail ]
  %exitcond1 = icmp eq i9 %s, %segment_V
  %s_1 = add i9 %s, 1
  br i1 %exitcond1, label %3, label %._crit_edge

._crit_edge:                                      ; preds = %0
  %empty = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 0, i64 256, i64 0)
  %tmp_9 = icmp eq i9 %s, %r_V_1
  %segment_len_V = select i1 %tmp_9, i9 %r_V_cast, i9 -256
  %tmp_s = sext i32 %curr_addr_a to i64
  %a_V_addr = getelementptr i256* %a_V, i64 %tmp_s
  %tmp_3_add_i32_shr = zext i9 %segment_len_V to i32
  %a_V_addr_rd_req = call i1 @_ssdm_op_ReadReq.m_axi.i256P(i256* %a_V_addr, i32 %tmp_3_add_i32_shr)
  br label %burst.rd.header

burst.rd.header:                                  ; preds = %burst.rd.body, %._crit_edge
  %indvar = phi i9 [ 0, %._crit_edge ], [ %indvar_next, %burst.rd.body ]
  %exitcond3 = icmp eq i9 %indvar, %segment_len_V
  %indvar_next = add i9 %indvar, 1
  br i1 %exitcond3, label %burst.rd.end, label %burst.rd.body

burst.rd.body:                                    ; preds = %burst.rd.header
  %empty_7 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 0, i64 256, i64 0)
  %burstread_rbegin = call i32 (...)* @_ssdm_op_SpecRegionBegin([17 x i8]* @burstread_OC_region_s)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str10)
  call void (...)* @_ssdm_op_SpecLoopName([23 x i8]* @memcpy_OC_buff_a_OC_s)
  %a_V_addr_read = call i256 @_ssdm_op_Read.m_axi.i256P(i256* %a_V_addr)
  %tmp_1 = zext i9 %indvar to i64
  %buff_a_addr = getelementptr [256 x i256]* %buff_a, i64 0, i64 %tmp_1
  store i256 %a_V_addr_read, i256* %buff_a_addr, align 8
  %burstread_rend = call i32 (...)* @_ssdm_op_SpecRegionEnd([17 x i8]* @burstread_OC_region_s, i32 %burstread_rbegin)
  br label %burst.rd.header

burst.rd.end:                                     ; preds = %burst.rd.header
  %tmp_5 = sext i32 %curr_addr_b to i64
  %a_V_addr_1 = getelementptr i256* %a_V, i64 %tmp_5
  %a_V_addr_1_rd_req = call i1 @_ssdm_op_ReadReq.m_axi.i256P(i256* %a_V_addr_1, i32 %tmp_3_add_i32_shr)
  br label %burst.rd.header9

burst.rd.header9:                                 ; preds = %burst.rd.body10, %burst.rd.end
  %indvar1 = phi i9 [ 0, %burst.rd.end ], [ %indvar_next1, %burst.rd.body10 ]
  %exitcond = icmp eq i9 %indvar1, %segment_len_V
  %indvar_next1 = add i9 %indvar1, 1
  br i1 %exitcond, label %burst.rd.end8.preheader, label %burst.rd.body10

burst.rd.end8.preheader:                          ; preds = %burst.rd.header9
  br label %burst.rd.end8

burst.rd.body10:                                  ; preds = %burst.rd.header9
  %empty_8 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 0, i64 256, i64 0)
  %burstread_rbegin1 = call i32 (...)* @_ssdm_op_SpecRegionBegin([17 x i8]* @burstread_OC_region_s)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str11)
  call void (...)* @_ssdm_op_SpecLoopName([23 x i8]* @memcpy_OC_buff_b_OC_s)
  %a_V_addr_1_read = call i256 @_ssdm_op_Read.m_axi.i256P(i256* %a_V_addr_1)
  %tmp_4 = zext i9 %indvar1 to i64
  %buff_b_addr = getelementptr [256 x i256]* %buff_b, i64 0, i64 %tmp_4
  store i256 %a_V_addr_1_read, i256* %buff_b_addr, align 8
  %burstread_rend20 = call i32 (...)* @_ssdm_op_SpecRegionEnd([17 x i8]* @burstread_OC_region_s, i32 %burstread_rbegin1)
  br label %burst.rd.header9

burst.rd.end8:                                    ; preds = %burst.rd.end8.preheader, %1
  %i = phi i9 [ %i_1, %1 ], [ 0, %burst.rd.end8.preheader ]
  %exitcond2 = icmp eq i9 %i, %segment_len_V
  %i_1 = add i9 %i, 1
  br i1 %exitcond2, label %2, label %1

; <label>:1                                       ; preds = %burst.rd.end8
  %empty_9 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 0, i64 256, i64 0)
  call void (...)* @_ssdm_op_SpecLoopName([11 x i8]* @p_str3) nounwind
  %tmp_8 = call i32 (...)* @_ssdm_op_SpecRegionBegin([11 x i8]* @p_str3)
  call void (...)* @_ssdm_op_SpecPipeline(i32 -1, i32 1, i32 1, i32 0, [1 x i8]* @p_str1) nounwind
  %tmp_6 = zext i9 %i to i64
  %buff_a_addr_1 = getelementptr [256 x i256]* %buff_a, i64 0, i64 %tmp_6
  %buff_b_addr_1 = getelementptr [256 x i256]* %buff_b, i64 0, i64 %tmp_6
  %buff_a_load = load i256* %buff_a_addr_1, align 32
  %tmp_3 = trunc i256 %buff_a_load to i32
  %buff_b_load = load i256* %buff_b_addr_1, align 32
  %tmp_14 = trunc i256 %buff_b_load to i32
  %tmp_2 = bitcast i32 %tmp_3 to float
  %tmp_10 = bitcast i32 %tmp_14 to float
  %tmp_11 = fadd float %tmp_2, %tmp_10
  %p_Repl2_s = bitcast float %tmp_11 to i32
  %p_Result_s = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_a_load, i32 32, i32 63)
  %p_Result_1_1 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_b_load, i32 32, i32 63)
  %tmp_12_1 = bitcast i32 %p_Result_s to float
  %tmp_13_1 = bitcast i32 %p_Result_1_1 to float
  %tmp_14_1 = fadd float %tmp_12_1, %tmp_13_1
  %p_Repl2_1 = bitcast float %tmp_14_1 to i32
  %p_Result_2 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_a_load, i32 64, i32 95)
  %p_Result_1_2 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_b_load, i32 64, i32 95)
  %tmp_12_2 = bitcast i32 %p_Result_2 to float
  %tmp_13_2 = bitcast i32 %p_Result_1_2 to float
  %tmp_14_2 = fadd float %tmp_12_2, %tmp_13_2
  %p_Repl2_2 = bitcast float %tmp_14_2 to i32
  %p_Result_3 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_a_load, i32 96, i32 127)
  %p_Result_1_3 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_b_load, i32 96, i32 127)
  %tmp_12_3 = bitcast i32 %p_Result_3 to float
  %tmp_13_3 = bitcast i32 %p_Result_1_3 to float
  %tmp_14_3 = fadd float %tmp_12_3, %tmp_13_3
  %p_Repl2_3 = bitcast float %tmp_14_3 to i32
  %p_Result_4 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_a_load, i32 128, i32 159)
  %p_Result_1_4 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_b_load, i32 128, i32 159)
  %tmp_12_4 = bitcast i32 %p_Result_4 to float
  %tmp_13_4 = bitcast i32 %p_Result_1_4 to float
  %tmp_14_4 = fadd float %tmp_12_4, %tmp_13_4
  %p_Repl2_4 = bitcast float %tmp_14_4 to i32
  %p_Result_5 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_a_load, i32 160, i32 191)
  %p_Result_1_5 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_b_load, i32 160, i32 191)
  %tmp_12_5 = bitcast i32 %p_Result_5 to float
  %tmp_13_5 = bitcast i32 %p_Result_1_5 to float
  %tmp_14_5 = fadd float %tmp_12_5, %tmp_13_5
  %p_Repl2_5 = bitcast float %tmp_14_5 to i32
  %p_Result_6 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_a_load, i32 192, i32 223)
  %p_Result_1_6 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_b_load, i32 192, i32 223)
  %tmp_12_6 = bitcast i32 %p_Result_6 to float
  %tmp_13_6 = bitcast i32 %p_Result_1_6 to float
  %tmp_14_6 = fadd float %tmp_12_6, %tmp_13_6
  %p_Repl2_6 = bitcast float %tmp_14_6 to i32
  %p_Result_7 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_a_load, i32 224, i32 255)
  %p_Result_1_7 = call i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256 %buff_b_load, i32 224, i32 255)
  %tmp_12_7 = bitcast i32 %p_Result_7 to float
  %tmp_13_7 = bitcast i32 %p_Result_1_7 to float
  %tmp_14_7 = fadd float %tmp_12_7, %tmp_13_7
  %p_Repl2_7 = bitcast float %tmp_14_7 to i32
  %p_Result_s_10 = call i256 @_ssdm_op_BitConcatenate.i256.i32.i32.i32.i32.i32.i32.i32.i32(i32 %p_Repl2_7, i32 %p_Repl2_6, i32 %p_Repl2_5, i32 %p_Repl2_4, i32 %p_Repl2_3, i32 %p_Repl2_2, i32 %p_Repl2_1, i32 %p_Repl2_s)
  %buff_V_addr = getelementptr [256 x i256]* %buff_V, i64 0, i64 %tmp_6
  store i256 %p_Result_s_10, i256* %buff_V_addr, align 32
  %empty_11 = call i32 (...)* @_ssdm_op_SpecRegionEnd([11 x i8]* @p_str3, i32 %tmp_8)
  br label %burst.rd.end8

; <label>:2                                       ; preds = %burst.rd.end8
  %tmp_7 = sext i32 %curr_addr_c to i64
  %a_V_addr_2 = getelementptr i256* %a_V, i64 %tmp_7
  %a_V_addr_2_wr_req = call i1 @_ssdm_op_WriteReq.m_axi.i256P(i256* %a_V_addr_2, i32 %tmp_3_add_i32_shr)
  br label %burst.wr.header

burst.wr.header:                                  ; preds = %burst.wr.body, %2
  %indvar2 = phi i9 [ 0, %2 ], [ %indvar_next2, %burst.wr.body ]
  %exitcond4 = icmp eq i9 %indvar2, %segment_len_V
  %indvar_next2 = add i9 %indvar2, 1
  br i1 %exitcond4, label %memcpy.tail, label %burst.wr.body

burst.wr.body:                                    ; preds = %burst.wr.header
  %empty_12 = call i32 (...)* @_ssdm_op_SpecLoopTripCount(i64 0, i64 256, i64 0)
  %burstwrite_rbegin = call i32 (...)* @_ssdm_op_SpecRegionBegin([18 x i8]* @burstwrite_OC_region)
  call void (...)* @_ssdm_op_SpecPipeline(i32 1, i32 1, i32 1, i32 0, [1 x i8]* @p_str12)
  call void (...)* @_ssdm_op_SpecLoopName([23 x i8]* @memcpy_OC_a_OC_V_OC_s)
  %tmp_12 = zext i9 %indvar2 to i64
  %buff_V_addr_1 = getelementptr [256 x i256]* %buff_V, i64 0, i64 %tmp_12
  %buff_V_load = load i256* %buff_V_addr_1, align 8
  call void @_ssdm_op_Write.m_axi.i256P(i256* %a_V_addr_2, i256 %buff_V_load, i32 -1)
  %burstwrite_rend = call i32 (...)* @_ssdm_op_SpecRegionEnd([18 x i8]* @burstwrite_OC_region, i32 %burstwrite_rbegin)
  br label %burst.wr.header

memcpy.tail:                                      ; preds = %burst.wr.header
  %a_V_addr_2_wr_resp = call i1 @_ssdm_op_WriteResp.m_axi.i256P(i256* %a_V_addr_2)
  %curr_addr_a_1 = add nsw i32 %curr_addr_a, 256
  %curr_addr_b_1 = add nsw i32 %curr_addr_b, 256
  %curr_addr_c_1 = add nsw i32 %curr_addr_c, 256
  br label %0

; <label>:3                                       ; preds = %0
  ret void
}

define weak i1 @_ssdm_op_WriteResp.m_axi.i256P(i256*) {
entry:
  ret i1 true
}

define weak i1 @_ssdm_op_WriteReq.m_axi.i256P(i256*, i32) {
entry:
  ret i1 true
}

define weak void @_ssdm_op_Write.m_axi.i256P(i256*, i256, i32) {
entry:
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecRegionEnd(...) {
entry:
  ret i32 0
}

define weak i32 @_ssdm_op_SpecRegionBegin(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecPipeline(...) nounwind {
entry:
  ret void
}

define weak i32 @_ssdm_op_SpecLoopTripCount(...) {
entry:
  ret i32 0
}

define weak void @_ssdm_op_SpecLoopName(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i1 @_ssdm_op_ReadReq.m_axi.i256P(i256*, i32) {
entry:
  ret i1 true
}

define weak i256 @_ssdm_op_Read.m_axi.i256P(i256*) {
entry:
  %empty = load i256* %0
  ret i256 %empty
}

define weak i32 @_ssdm_op_Read.ap_vld.i32(i32) {
entry:
  ret i32 %0
}

define weak i16 @_ssdm_op_Read.ap_vld.i16(i16) {
entry:
  ret i16 %0
}

define weak i8 @_ssdm_op_PartSelect.i8.i16.i32.i32(i16, i32, i32) nounwind readnone {
entry:
  %empty = call i16 @llvm.part.select.i16(i16 %0, i32 %1, i32 %2)
  %empty_13 = trunc i16 %empty to i8
  ret i8 %empty_13
}

define weak i32 @_ssdm_op_PartSelect.i32.i256.i32.i32(i256, i32, i32) nounwind readnone {
entry:
  %empty = call i256 @llvm.part.select.i256(i256 %0, i32 %1, i32 %2)
  %empty_14 = trunc i256 %empty to i32
  ret i32 %empty_14
}

define weak i256 @_ssdm_op_BitConcatenate.i256.i32.i32.i32.i32.i32.i32.i32.i32(i32, i32, i32, i32, i32, i32, i32, i32) nounwind readnone {
entry:
  %empty = zext i32 %6 to i64
  %empty_15 = zext i32 %7 to i64
  %empty_16 = shl i64 %empty, 32
  %empty_17 = or i64 %empty_16, %empty_15
  %empty_18 = zext i32 %5 to i96
  %empty_19 = zext i64 %empty_17 to i96
  %empty_20 = shl i96 %empty_18, 64
  %empty_21 = or i96 %empty_20, %empty_19
  %empty_22 = zext i32 %4 to i128
  %empty_23 = zext i96 %empty_21 to i128
  %empty_24 = shl i128 %empty_22, 96
  %empty_25 = or i128 %empty_24, %empty_23
  %empty_26 = zext i32 %3 to i160
  %empty_27 = zext i128 %empty_25 to i160
  %empty_28 = shl i160 %empty_26, 128
  %empty_29 = or i160 %empty_28, %empty_27
  %empty_30 = zext i32 %2 to i192
  %empty_31 = zext i160 %empty_29 to i192
  %empty_32 = shl i192 %empty_30, 160
  %empty_33 = or i192 %empty_32, %empty_31
  %empty_34 = zext i32 %1 to i224
  %empty_35 = zext i192 %empty_33 to i224
  %empty_36 = shl i224 %empty_34, 192
  %empty_37 = or i224 %empty_36, %empty_35
  %empty_38 = zext i32 %0 to i256
  %empty_39 = zext i224 %empty_37 to i256
  %empty_40 = shl i256 %empty_38, 224
  %empty_41 = or i256 %empty_40, %empty_39
  ret i256 %empty_41
}

declare void @_GLOBAL__I_a() nounwind section ".text.startup"

!opencl.kernels = !{!0, !7, !7, !7, !13, !19, !19, !13, !21, !21, !13, !23, !23, !13, !25, !25, !13, !27, !27, !13, !29, !29, !13, !31, !31, !13, !13, !31, !31, !13, !13, !31, !31, !13, !13, !31, !31, !13, !13, !31, !31, !13, !13, !31, !31, !13, !34, !34, !13, !13, !13, !31, !31, !13, !13, !36, !39, !42, !42, !39, !48, !48, !39, !50, !50, !39, !52, !52, !39, !54, !54, !39, !56, !56, !39, !58, !58, !60, !60, !13, !13, !62, !13, !13, !64, !67, !67, !13, !73, !76, !76, !78, !13, !13, !13, !81, !81, !83, !83, !83, !83, !13, !13, !85, !87, !13, !60, !60, !13, !89, !31, !31, !91, !13, !13, !13, !34, !34, !83, !83, !13, !13, !13, !93, !93, !95, !97, !97, !13, !99, !13, !13, !13, !101, !101, !103, !103, !105, !106, !89, !91, !89, !91, !13, !13, !13, !13, !13, !13, !13, !13}
!hls.encrypted.func = !{}
!llvm.map.gv = !{!107}

!0 = metadata !{null, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 0, i32 0, i32 0, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"data_t*", metadata !"ap_uint<16>", metadata !"int", metadata !"int", metadata !"int"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"volatile", metadata !"", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_name", metadata !"a", metadata !"n", metadata !"a_addr", metadata !"b_addr", metadata !"c_addr"}
!6 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!7 = metadata !{null, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !6}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 0}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_concat_ref<224, struct ap_concat_ref<192, struct ap_concat_ref<160, struct ap_concat_ref<128, struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !""}
!12 = metadata !{metadata !"kernel_arg_name", metadata !"ref"}
!13 = metadata !{null, metadata !14, metadata !15, metadata !16, metadata !17, metadata !18, metadata !6}
!14 = metadata !{metadata !"kernel_arg_addr_space"}
!15 = metadata !{metadata !"kernel_arg_access_qual"}
!16 = metadata !{metadata !"kernel_arg_type"}
!17 = metadata !{metadata !"kernel_arg_type_qual"}
!18 = metadata !{metadata !"kernel_arg_name"}
!19 = metadata !{null, metadata !8, metadata !9, metadata !20, metadata !11, metadata !12, metadata !6}
!20 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_concat_ref<192, struct ap_concat_ref<160, struct ap_concat_ref<128, struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &"}
!21 = metadata !{null, metadata !8, metadata !9, metadata !22, metadata !11, metadata !12, metadata !6}
!22 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_concat_ref<160, struct ap_concat_ref<128, struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &"}
!23 = metadata !{null, metadata !8, metadata !9, metadata !24, metadata !11, metadata !12, metadata !6}
!24 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_concat_ref<128, struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &"}
!25 = metadata !{null, metadata !8, metadata !9, metadata !26, metadata !11, metadata !12, metadata !6}
!26 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &"}
!27 = metadata !{null, metadata !8, metadata !9, metadata !28, metadata !11, metadata !12, metadata !6}
!28 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &"}
!29 = metadata !{null, metadata !8, metadata !9, metadata !30, metadata !11, metadata !12, metadata !6}
!30 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> > &"}
!31 = metadata !{null, metadata !8, metadata !9, metadata !32, metadata !11, metadata !33, metadata !6}
!32 = metadata !{metadata !"kernel_arg_type", metadata !"int"}
!33 = metadata !{metadata !"kernel_arg_name", metadata !"op"}
!34 = metadata !{null, metadata !8, metadata !9, metadata !35, metadata !11, metadata !33, metadata !6}
!35 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, true> &"}
!36 = metadata !{null, metadata !8, metadata !9, metadata !37, metadata !11, metadata !38, metadata !6}
!37 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int<256> &"}
!38 = metadata !{metadata !"kernel_arg_name", metadata !"op2"}
!39 = metadata !{null, metadata !8, metadata !9, metadata !40, metadata !11, metadata !41, metadata !6}
!40 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<32, true> &"}
!41 = metadata !{metadata !"kernel_arg_name", metadata !"a2"}
!42 = metadata !{null, metadata !43, metadata !44, metadata !45, metadata !46, metadata !47, metadata !6}
!43 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0}
!44 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!45 = metadata !{metadata !"kernel_arg_type", metadata !"struct ap_concat_ref<192, struct ap_concat_ref<160, struct ap_concat_ref<128, struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &", metadata !"struct ap_int_base<32, true, true> &"}
!46 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!47 = metadata !{metadata !"kernel_arg_name", metadata !"bv1", metadata !"bv2"}
!48 = metadata !{null, metadata !43, metadata !44, metadata !49, metadata !46, metadata !47, metadata !6}
!49 = metadata !{metadata !"kernel_arg_type", metadata !"struct ap_concat_ref<160, struct ap_concat_ref<128, struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &", metadata !"struct ap_int_base<32, true, true> &"}
!50 = metadata !{null, metadata !43, metadata !44, metadata !51, metadata !46, metadata !47, metadata !6}
!51 = metadata !{metadata !"kernel_arg_type", metadata !"struct ap_concat_ref<128, struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &", metadata !"struct ap_int_base<32, true, true> &"}
!52 = metadata !{null, metadata !43, metadata !44, metadata !53, metadata !46, metadata !47, metadata !6}
!53 = metadata !{metadata !"kernel_arg_type", metadata !"struct ap_concat_ref<96, struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &", metadata !"struct ap_int_base<32, true, true> &"}
!54 = metadata !{null, metadata !43, metadata !44, metadata !55, metadata !46, metadata !47, metadata !6}
!55 = metadata !{metadata !"kernel_arg_type", metadata !"struct ap_concat_ref<64, struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> >, 32, struct ap_int_base<32, true, true> > &", metadata !"struct ap_int_base<32, true, true> &"}
!56 = metadata !{null, metadata !43, metadata !44, metadata !57, metadata !46, metadata !47, metadata !6}
!57 = metadata !{metadata !"kernel_arg_type", metadata !"struct ap_concat_ref<32, struct ap_int_base<32, true, true>, 32, struct ap_int_base<32, true, true> > &", metadata !"struct ap_int_base<32, true, true> &"}
!58 = metadata !{null, metadata !43, metadata !44, metadata !59, metadata !46, metadata !47, metadata !6}
!59 = metadata !{metadata !"kernel_arg_type", metadata !"struct ap_int_base<32, true, true> &", metadata !"struct ap_int_base<32, true, true> &"}
!60 = metadata !{null, metadata !8, metadata !9, metadata !32, metadata !11, metadata !61, metadata !6}
!61 = metadata !{metadata !"kernel_arg_name", metadata !"val"}
!62 = metadata !{null, metadata !8, metadata !9, metadata !63, metadata !11, metadata !38, metadata !6}
!63 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int<32> &"}
!64 = metadata !{null, metadata !43, metadata !44, metadata !65, metadata !46, metadata !66, metadata !6}
!65 = metadata !{metadata !"kernel_arg_type", metadata !"int", metadata !"int"}
!66 = metadata !{metadata !"kernel_arg_name", metadata !"Hi", metadata !"Lo"}
!67 = metadata !{null, metadata !68, metadata !69, metadata !70, metadata !71, metadata !72, metadata !6}
!68 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 0, i32 0}
!69 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!70 = metadata !{metadata !"kernel_arg_type", metadata !"ap_int_base<256, true>*", metadata !"int", metadata !"int"}
!71 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!72 = metadata !{metadata !"kernel_arg_name", metadata !"bv", metadata !"h", metadata !"l"}
!73 = metadata !{null, metadata !43, metadata !44, metadata !74, metadata !46, metadata !75, metadata !6}
!74 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &", metadata !"ulong"}
!75 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"i_op"}
!76 = metadata !{null, metadata !8, metadata !9, metadata !77, metadata !11, metadata !33, metadata !6}
!77 = metadata !{metadata !"kernel_arg_type", metadata !"ulong"}
!78 = metadata !{null, metadata !43, metadata !44, metadata !79, metadata !46, metadata !80, metadata !6}
!79 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &", metadata !"const ap_int_base<64, false> &"}
!80 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"op2"}
!81 = metadata !{null, metadata !8, metadata !9, metadata !82, metadata !11, metadata !33, metadata !6}
!82 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<64, false> &"}
!83 = metadata !{null, metadata !8, metadata !9, metadata !84, metadata !11, metadata !33, metadata !6}
!84 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &"}
!85 = metadata !{null, metadata !8, metadata !9, metadata !86, metadata !11, metadata !38, metadata !6}
!86 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<16> &"}
!87 = metadata !{null, metadata !43, metadata !44, metadata !88, metadata !46, metadata !80, metadata !6}
!88 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &", metadata !"const ap_int_base<16, false> &"}
!89 = metadata !{null, metadata !43, metadata !44, metadata !90, metadata !46, metadata !75, metadata !6}
!90 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &", metadata !"int"}
!91 = metadata !{null, metadata !43, metadata !44, metadata !92, metadata !46, metadata !80, metadata !6}
!92 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<16, false> &", metadata !"const ap_int_base<32, true> &"}
!93 = metadata !{null, metadata !8, metadata !9, metadata !94, metadata !11, metadata !33, metadata !6}
!94 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<18, true> &"}
!95 = metadata !{null, metadata !43, metadata !44, metadata !96, metadata !46, metadata !75, metadata !6}
!96 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<17, true> &", metadata !"_Bool"}
!97 = metadata !{null, metadata !8, metadata !9, metadata !98, metadata !11, metadata !33, metadata !6}
!98 = metadata !{metadata !"kernel_arg_type", metadata !"_Bool"}
!99 = metadata !{null, metadata !43, metadata !44, metadata !100, metadata !46, metadata !80, metadata !6}
!100 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<17, true> &", metadata !"const ap_int_base<1, false> &"}
!101 = metadata !{null, metadata !8, metadata !9, metadata !102, metadata !11, metadata !33, metadata !6}
!102 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<1, false> &"}
!103 = metadata !{null, metadata !8, metadata !9, metadata !104, metadata !11, metadata !33, metadata !6}
!104 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<17, true> &"}
!105 = metadata !{null, metadata !43, metadata !44, metadata !90, metadata !46, metadata !80, metadata !6}
!106 = metadata !{null, metadata !8, metadata !9, metadata !35, metadata !11, metadata !38, metadata !6}
!107 = metadata !{metadata !108, [1 x i32]* @llvm_global_ctors_0}
!108 = metadata !{metadata !109}
!109 = metadata !{i32 0, i32 31, metadata !110}
!110 = metadata !{metadata !111}
!111 = metadata !{metadata !"llvm.global_ctors.0", metadata !112, metadata !"", i32 0, i32 31}
!112 = metadata !{metadata !113}
!113 = metadata !{i32 0, i32 0, i32 1}
!114 = metadata !{metadata !115}
!115 = metadata !{i32 0, i32 255, metadata !116}
!116 = metadata !{metadata !117}
!117 = metadata !{metadata !"a.V", metadata !118, metadata !"int256", i32 0, i32 255}
!118 = metadata !{metadata !119}
!119 = metadata !{i32 0, i32 511, i32 1}
!120 = metadata !{metadata !121}
!121 = metadata !{i32 0, i32 15, metadata !122}
!122 = metadata !{metadata !123}
!123 = metadata !{metadata !"n.V", metadata !124, metadata !"uint16", i32 0, i32 15}
!124 = metadata !{metadata !125}
!125 = metadata !{i32 0, i32 0, i32 0}
!126 = metadata !{metadata !127}
!127 = metadata !{i32 0, i32 31, metadata !128}
!128 = metadata !{metadata !129}
!129 = metadata !{metadata !"a_addr", metadata !124, metadata !"int", i32 0, i32 31}
!130 = metadata !{metadata !131}
!131 = metadata !{i32 0, i32 31, metadata !132}
!132 = metadata !{metadata !133}
!133 = metadata !{metadata !"b_addr", metadata !124, metadata !"int", i32 0, i32 31}
!134 = metadata !{metadata !135}
!135 = metadata !{i32 0, i32 31, metadata !136}
!136 = metadata !{metadata !137}
!137 = metadata !{metadata !"c_addr", metadata !124, metadata !"int", i32 0, i32 31}
