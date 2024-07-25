// Generator : SpinalHDL v1.7.1    git head : 0444bb76ab1d6e19f0ec46bc03c4769776deb7d5
// Component : Network
// Git hash  : 0141521e5ea7722a8d33fbe1c818b467e278ee21

`timescale 1ns/1ps

module Network (
  input               resetn,
  input               clk,
  input               i_stream_TVALID,
  output              i_stream_TREADY,
  input      [31:0]   i_stream__TDATA,
  output              o_stream_TVALID,
  input               o_stream_TREADY,
  output     [31:0]   o_stream__TDATA,
  output              o_stream__TLAST,
  input               residuals_axilite_awvalid,
  output              residuals_axilite_awready,
  input      [15:0]   residuals_axilite_awaddr,
  input      [2:0]    residuals_axilite_awprot,
  input               residuals_axilite_wvalid,
  output              residuals_axilite_wready,
  input      [31:0]   residuals_axilite_wdata,
  input      [3:0]    residuals_axilite_wstrb,
  output              residuals_axilite_bvalid,
  input               residuals_axilite_bready,
  output     [1:0]    residuals_axilite_bresp,
  input               residuals_axilite_arvalid,
  output              residuals_axilite_arready,
  input      [15:0]   residuals_axilite_araddr,
  input      [2:0]    residuals_axilite_arprot,
  output              residuals_axilite_rvalid,
  input               residuals_axilite_rready,
  output     [31:0]   residuals_axilite_rdata,
  output     [1:0]    residuals_axilite_rresp
);

  wire                residual_seq_axilite_awready;
  wire                residual_seq_axilite_wready;
  wire                residual_seq_axilite_bvalid;
  wire       [1:0]    residual_seq_axilite_bresp;
  wire                residual_seq_axilite_arready;
  wire                residual_seq_axilite_rvalid;
  wire       [31:0]   residual_seq_axilite_rdata;
  wire       [1:0]    residual_seq_axilite_rresp;
  wire                residual_seq_i_stream_ready;
  wire                residual_seq_o_stream_valid;
  wire       [31:0]   residual_seq_o_stream_payload_data;
  wire                residual_seq_o_stream_payload_last;

  BlockSequence residual_seq (
    .axilite_awvalid       (residuals_axilite_awvalid               ), //i
    .axilite_awready       (residual_seq_axilite_awready            ), //o
    .axilite_awaddr        (residuals_axilite_awaddr[15:0]          ), //i
    .axilite_awprot        (residuals_axilite_awprot[2:0]           ), //i
    .axilite_wvalid        (residuals_axilite_wvalid                ), //i
    .axilite_wready        (residual_seq_axilite_wready             ), //o
    .axilite_wdata         (residuals_axilite_wdata[31:0]           ), //i
    .axilite_wstrb         (residuals_axilite_wstrb[3:0]            ), //i
    .axilite_bvalid        (residual_seq_axilite_bvalid             ), //o
    .axilite_bready        (residuals_axilite_bready                ), //i
    .axilite_bresp         (residual_seq_axilite_bresp[1:0]         ), //o
    .axilite_arvalid       (residuals_axilite_arvalid               ), //i
    .axilite_arready       (residual_seq_axilite_arready            ), //o
    .axilite_araddr        (residuals_axilite_araddr[15:0]          ), //i
    .axilite_arprot        (residuals_axilite_arprot[2:0]           ), //i
    .axilite_rvalid        (residual_seq_axilite_rvalid             ), //o
    .axilite_rready        (residuals_axilite_rready                ), //i
    .axilite_rdata         (residual_seq_axilite_rdata[31:0]        ), //o
    .axilite_rresp         (residual_seq_axilite_rresp[1:0]         ), //o
    .i_stream_valid        (i_stream_TVALID                         ), //i
    .i_stream_ready        (residual_seq_i_stream_ready             ), //o
    .i_stream_payload_data (i_stream__TDATA[31:0]                   ), //i
    .o_stream_valid        (residual_seq_o_stream_valid             ), //o
    .o_stream_ready        (o_stream_TREADY                         ), //i
    .o_stream_payload_data (residual_seq_o_stream_payload_data[31:0]), //o
    .o_stream_payload_last (residual_seq_o_stream_payload_last      ), //o
    .resetn                (resetn                                  ), //i
    .clk                   (clk                                     )  //i
  );
  assign residuals_axilite_awready = residual_seq_axilite_awready;
  assign residuals_axilite_wready = residual_seq_axilite_wready;
  assign residuals_axilite_bvalid = residual_seq_axilite_bvalid;
  assign residuals_axilite_bresp = residual_seq_axilite_bresp;
  assign residuals_axilite_arready = residual_seq_axilite_arready;
  assign residuals_axilite_rvalid = residual_seq_axilite_rvalid;
  assign residuals_axilite_rdata = residual_seq_axilite_rdata;
  assign residuals_axilite_rresp = residual_seq_axilite_rresp;
  assign i_stream_TREADY = residual_seq_i_stream_ready;
  assign o_stream_TVALID = residual_seq_o_stream_valid;
  assign o_stream__TDATA = residual_seq_o_stream_payload_data;
  assign o_stream__TLAST = residual_seq_o_stream_payload_last;

endmodule

module BlockSequence (
  input               axilite_awvalid,
  output              axilite_awready,
  input      [15:0]   axilite_awaddr,
  input      [2:0]    axilite_awprot,
  input               axilite_wvalid,
  output              axilite_wready,
  input      [31:0]   axilite_wdata,
  input      [3:0]    axilite_wstrb,
  output              axilite_bvalid,
  input               axilite_bready,
  output     [1:0]    axilite_bresp,
  input               axilite_arvalid,
  output              axilite_arready,
  input      [15:0]   axilite_araddr,
  input      [2:0]    axilite_arprot,
  output              axilite_rvalid,
  input               axilite_rready,
  output     [31:0]   axilite_rdata,
  output     [1:0]    axilite_rresp,
  input               i_stream_valid,
  output              i_stream_ready,
  input      [31:0]   i_stream_payload_data,
  output              o_stream_valid,
  input               o_stream_ready,
  output     [31:0]   o_stream_payload_data,
  output              o_stream_payload_last,
  input               resetn,
  input               clk
);

  wire                controller_1_axilite_awready;
  wire                controller_1_axilite_wready;
  wire                controller_1_axilite_bvalid;
  wire       [1:0]    controller_1_axilite_bresp;
  wire                controller_1_axilite_arready;
  wire                controller_1_axilite_rvalid;
  wire       [31:0]   controller_1_axilite_rdata;
  wire       [1:0]    controller_1_axilite_rresp;
  wire                controller_1_i_stream_ready;
  wire                controller_1_o_stream_valid;
  wire       [31:0]   controller_1_o_stream_payload_data;
  wire                controller_1_o_stream_payload_last;
  wire       [19:0]   controller_1_signals_N;
  wire                controller_1_signals_T;
  wire                controller_1_ap_rst_n;
  wire                block_27_io_ap_chain_ap_idle;
  wire                block_27_io_ap_chain_ap_ready;
  wire                block_27_io_ap_chain_ap_done;
  wire                block_27_io_i_stream_ready;
  wire                block_27_io_o_stream_valid;
  wire       [31:0]   block_27_io_o_stream_payload_data;
  wire                block_28_io_ap_chain_ap_idle;
  wire                block_28_io_ap_chain_ap_ready;
  wire                block_28_io_ap_chain_ap_done;
  wire                block_28_io_i_stream_ready;
  wire                block_28_io_o_stream_valid;
  wire       [31:0]   block_28_io_o_stream_payload_data;
  wire                block_29_io_ap_chain_ap_idle;
  wire                block_29_io_ap_chain_ap_ready;
  wire                block_29_io_ap_chain_ap_done;
  wire                block_29_io_i_stream_ready;
  wire                block_29_io_o_stream_valid;
  wire       [31:0]   block_29_io_o_stream_payload_data;
  wire                block_30_io_ap_chain_ap_idle;
  wire                block_30_io_ap_chain_ap_ready;
  wire                block_30_io_ap_chain_ap_done;
  wire                block_30_io_i_stream_ready;
  wire                block_30_io_o_stream_valid;
  wire       [31:0]   block_30_io_o_stream_payload_data;
  wire                block_31_io_ap_chain_ap_idle;
  wire                block_31_io_ap_chain_ap_ready;
  wire                block_31_io_ap_chain_ap_done;
  wire                block_31_io_i_stream_ready;
  wire                block_31_io_o_stream_valid;
  wire       [31:0]   block_31_io_o_stream_payload_data;
  wire                block_32_io_ap_chain_ap_idle;
  wire                block_32_io_ap_chain_ap_ready;
  wire                block_32_io_ap_chain_ap_done;
  wire                block_32_io_i_stream_ready;
  wire                block_32_io_o_stream_valid;
  wire       [31:0]   block_32_io_o_stream_payload_data;
  wire                block_33_io_ap_chain_ap_idle;
  wire                block_33_io_ap_chain_ap_ready;
  wire                block_33_io_ap_chain_ap_done;
  wire                block_33_io_i_stream_ready;
  wire                block_33_io_o_stream_valid;
  wire       [31:0]   block_33_io_o_stream_payload_data;
  wire                block_34_io_ap_chain_ap_idle;
  wire                block_34_io_ap_chain_ap_ready;
  wire                block_34_io_ap_chain_ap_done;
  wire                block_34_io_i_stream_ready;
  wire                block_34_io_o_stream_valid;
  wire       [31:0]   block_34_io_o_stream_payload_data;
  wire                block_35_io_ap_chain_ap_idle;
  wire                block_35_io_ap_chain_ap_ready;
  wire                block_35_io_ap_chain_ap_done;
  wire                block_35_io_i_stream_ready;
  wire                block_35_io_o_stream_valid;
  wire       [31:0]   block_35_io_o_stream_payload_data;
  wire                block_36_io_ap_chain_ap_idle;
  wire                block_36_io_ap_chain_ap_ready;
  wire                block_36_io_ap_chain_ap_done;
  wire                block_36_io_i_stream_ready;
  wire                block_36_io_o_stream_valid;
  wire       [31:0]   block_36_io_o_stream_payload_data;
  wire                block_37_io_ap_chain_ap_idle;
  wire                block_37_io_ap_chain_ap_ready;
  wire                block_37_io_ap_chain_ap_done;
  wire                block_37_io_i_stream_ready;
  wire                block_37_io_o_stream_valid;
  wire       [31:0]   block_37_io_o_stream_payload_data;
  wire                block_38_io_ap_chain_ap_idle;
  wire                block_38_io_ap_chain_ap_ready;
  wire                block_38_io_ap_chain_ap_done;
  wire                block_38_io_i_stream_ready;
  wire                block_38_io_o_stream_valid;
  wire       [31:0]   block_38_io_o_stream_payload_data;
  wire                block_39_io_ap_chain_ap_idle;
  wire                block_39_io_ap_chain_ap_ready;
  wire                block_39_io_ap_chain_ap_done;
  wire                block_39_io_i_stream_ready;
  wire                block_39_io_o_stream_valid;
  wire       [31:0]   block_39_io_o_stream_payload_data;
  wire                block_40_io_ap_chain_ap_idle;
  wire                block_40_io_ap_chain_ap_ready;
  wire                block_40_io_ap_chain_ap_done;
  wire                block_40_io_i_stream_ready;
  wire                block_40_io_o_stream_valid;
  wire       [31:0]   block_40_io_o_stream_payload_data;
  wire                block_41_io_ap_chain_ap_idle;
  wire                block_41_io_ap_chain_ap_ready;
  wire                block_41_io_ap_chain_ap_done;
  wire                block_41_io_i_stream_ready;
  wire                block_41_io_o_stream_valid;
  wire       [31:0]   block_41_io_o_stream_payload_data;
  wire                block_42_io_ap_chain_ap_idle;
  wire                block_42_io_ap_chain_ap_ready;
  wire                block_42_io_ap_chain_ap_done;
  wire                block_42_io_i_stream_ready;
  wire                block_42_io_o_stream_valid;
  wire       [31:0]   block_42_io_o_stream_payload_data;
  wire                block_43_io_ap_chain_ap_idle;
  wire                block_43_io_ap_chain_ap_ready;
  wire                block_43_io_ap_chain_ap_done;
  wire                block_43_io_i_stream_ready;
  wire                block_43_io_o_stream_valid;
  wire       [31:0]   block_43_io_o_stream_payload_data;
  wire                block_44_io_ap_chain_ap_idle;
  wire                block_44_io_ap_chain_ap_ready;
  wire                block_44_io_ap_chain_ap_done;
  wire                block_44_io_i_stream_ready;
  wire                block_44_io_o_stream_valid;
  wire       [31:0]   block_44_io_o_stream_payload_data;
  wire                block_45_io_ap_chain_ap_idle;
  wire                block_45_io_ap_chain_ap_ready;
  wire                block_45_io_ap_chain_ap_done;
  wire                block_45_io_i_stream_ready;
  wire                block_45_io_o_stream_valid;
  wire       [31:0]   block_45_io_o_stream_payload_data;
  wire                block_46_io_ap_chain_ap_idle;
  wire                block_46_io_ap_chain_ap_ready;
  wire                block_46_io_ap_chain_ap_done;
  wire                block_46_io_i_stream_ready;
  wire                block_46_io_o_stream_valid;
  wire       [31:0]   block_46_io_o_stream_payload_data;
  wire                block_47_io_ap_chain_ap_idle;
  wire                block_47_io_ap_chain_ap_ready;
  wire                block_47_io_ap_chain_ap_done;
  wire                block_47_io_i_stream_ready;
  wire                block_47_io_o_stream_valid;
  wire       [31:0]   block_47_io_o_stream_payload_data;
  wire                block_48_io_ap_chain_ap_idle;
  wire                block_48_io_ap_chain_ap_ready;
  wire                block_48_io_ap_chain_ap_done;
  wire                block_48_io_i_stream_ready;
  wire                block_48_io_o_stream_valid;
  wire       [31:0]   block_48_io_o_stream_payload_data;
  wire                block_49_io_ap_chain_ap_idle;
  wire                block_49_io_ap_chain_ap_ready;
  wire                block_49_io_ap_chain_ap_done;
  wire                block_49_io_i_stream_ready;
  wire                block_49_io_o_stream_valid;
  wire       [31:0]   block_49_io_o_stream_payload_data;
  wire                block_50_io_ap_chain_ap_idle;
  wire                block_50_io_ap_chain_ap_ready;
  wire                block_50_io_ap_chain_ap_done;
  wire                block_50_io_i_stream_ready;
  wire                block_50_io_o_stream_valid;
  wire       [31:0]   block_50_io_o_stream_payload_data;
  wire                block_51_io_ap_chain_ap_idle;
  wire                block_51_io_ap_chain_ap_ready;
  wire                block_51_io_ap_chain_ap_done;
  wire                block_51_io_i_stream_ready;
  wire                block_51_io_o_stream_valid;
  wire       [31:0]   block_51_io_o_stream_payload_data;
  wire                block_52_io_ap_chain_ap_idle;
  wire                block_52_io_ap_chain_ap_ready;
  wire                block_52_io_ap_chain_ap_done;
  wire                block_52_io_i_stream_ready;
  wire                block_52_io_o_stream_valid;
  wire       [31:0]   block_52_io_o_stream_payload_data;
  wire       [19:0]   manager_26_signals_O_N;
  wire                manager_26_signals_O_T;
  wire                manager_26_ap_chain_ap_start;
  wire                manager_26_ap_chain_ap_continue;
  wire       [19:0]   manager_27_signals_O_N;
  wire                manager_27_signals_O_T;
  wire                manager_27_ap_chain_ap_start;
  wire                manager_27_ap_chain_ap_continue;
  wire       [19:0]   manager_28_signals_O_N;
  wire                manager_28_signals_O_T;
  wire                manager_28_ap_chain_ap_start;
  wire                manager_28_ap_chain_ap_continue;
  wire       [19:0]   manager_29_signals_O_N;
  wire                manager_29_signals_O_T;
  wire                manager_29_ap_chain_ap_start;
  wire                manager_29_ap_chain_ap_continue;
  wire       [19:0]   manager_30_signals_O_N;
  wire                manager_30_signals_O_T;
  wire                manager_30_ap_chain_ap_start;
  wire                manager_30_ap_chain_ap_continue;
  wire       [19:0]   manager_31_signals_O_N;
  wire                manager_31_signals_O_T;
  wire                manager_31_ap_chain_ap_start;
  wire                manager_31_ap_chain_ap_continue;
  wire       [19:0]   manager_32_signals_O_N;
  wire                manager_32_signals_O_T;
  wire                manager_32_ap_chain_ap_start;
  wire                manager_32_ap_chain_ap_continue;
  wire       [19:0]   manager_33_signals_O_N;
  wire                manager_33_signals_O_T;
  wire                manager_33_ap_chain_ap_start;
  wire                manager_33_ap_chain_ap_continue;
  wire       [19:0]   manager_34_signals_O_N;
  wire                manager_34_signals_O_T;
  wire                manager_34_ap_chain_ap_start;
  wire                manager_34_ap_chain_ap_continue;
  wire       [19:0]   manager_35_signals_O_N;
  wire                manager_35_signals_O_T;
  wire                manager_35_ap_chain_ap_start;
  wire                manager_35_ap_chain_ap_continue;
  wire       [19:0]   manager_36_signals_O_N;
  wire                manager_36_signals_O_T;
  wire                manager_36_ap_chain_ap_start;
  wire                manager_36_ap_chain_ap_continue;
  wire       [19:0]   manager_37_signals_O_N;
  wire                manager_37_signals_O_T;
  wire                manager_37_ap_chain_ap_start;
  wire                manager_37_ap_chain_ap_continue;
  wire       [19:0]   manager_38_signals_O_N;
  wire                manager_38_signals_O_T;
  wire                manager_38_ap_chain_ap_start;
  wire                manager_38_ap_chain_ap_continue;
  wire       [19:0]   manager_39_signals_O_N;
  wire                manager_39_signals_O_T;
  wire                manager_39_ap_chain_ap_start;
  wire                manager_39_ap_chain_ap_continue;
  wire       [19:0]   manager_40_signals_O_N;
  wire                manager_40_signals_O_T;
  wire                manager_40_ap_chain_ap_start;
  wire                manager_40_ap_chain_ap_continue;
  wire       [19:0]   manager_41_signals_O_N;
  wire                manager_41_signals_O_T;
  wire                manager_41_ap_chain_ap_start;
  wire                manager_41_ap_chain_ap_continue;
  wire       [19:0]   manager_42_signals_O_N;
  wire                manager_42_signals_O_T;
  wire                manager_42_ap_chain_ap_start;
  wire                manager_42_ap_chain_ap_continue;
  wire       [19:0]   manager_43_signals_O_N;
  wire                manager_43_signals_O_T;
  wire                manager_43_ap_chain_ap_start;
  wire                manager_43_ap_chain_ap_continue;
  wire       [19:0]   manager_44_signals_O_N;
  wire                manager_44_signals_O_T;
  wire                manager_44_ap_chain_ap_start;
  wire                manager_44_ap_chain_ap_continue;
  wire       [19:0]   manager_45_signals_O_N;
  wire                manager_45_signals_O_T;
  wire                manager_45_ap_chain_ap_start;
  wire                manager_45_ap_chain_ap_continue;
  wire       [19:0]   manager_46_signals_O_N;
  wire                manager_46_signals_O_T;
  wire                manager_46_ap_chain_ap_start;
  wire                manager_46_ap_chain_ap_continue;
  wire       [19:0]   manager_47_signals_O_N;
  wire                manager_47_signals_O_T;
  wire                manager_47_ap_chain_ap_start;
  wire                manager_47_ap_chain_ap_continue;
  wire       [19:0]   manager_48_signals_O_N;
  wire                manager_48_signals_O_T;
  wire                manager_48_ap_chain_ap_start;
  wire                manager_48_ap_chain_ap_continue;
  wire       [19:0]   manager_49_signals_O_N;
  wire                manager_49_signals_O_T;
  wire                manager_49_ap_chain_ap_start;
  wire                manager_49_ap_chain_ap_continue;
  wire       [19:0]   manager_50_signals_O_N;
  wire                manager_50_signals_O_T;
  wire                manager_50_ap_chain_ap_start;
  wire                manager_50_ap_chain_ap_continue;
  wire       [19:0]   manager_51_signals_O_N;
  wire                manager_51_signals_O_T;
  wire                manager_51_ap_chain_ap_start;
  wire                manager_51_ap_chain_ap_continue;
  wire                fifo_25_io_i_stream_ready;
  wire                fifo_25_io_o_stream_valid;
  wire       [31:0]   fifo_25_io_o_stream_payload_data;
  wire                fifo_26_io_i_stream_ready;
  wire                fifo_26_io_o_stream_valid;
  wire       [31:0]   fifo_26_io_o_stream_payload_data;
  wire                fifo_27_io_i_stream_ready;
  wire                fifo_27_io_o_stream_valid;
  wire       [31:0]   fifo_27_io_o_stream_payload_data;
  wire                fifo_28_io_i_stream_ready;
  wire                fifo_28_io_o_stream_valid;
  wire       [31:0]   fifo_28_io_o_stream_payload_data;
  wire                fifo_29_io_i_stream_ready;
  wire                fifo_29_io_o_stream_valid;
  wire       [31:0]   fifo_29_io_o_stream_payload_data;
  wire                fifo_30_io_i_stream_ready;
  wire                fifo_30_io_o_stream_valid;
  wire       [31:0]   fifo_30_io_o_stream_payload_data;
  wire                fifo_31_io_i_stream_ready;
  wire                fifo_31_io_o_stream_valid;
  wire       [31:0]   fifo_31_io_o_stream_payload_data;
  wire                fifo_32_io_i_stream_ready;
  wire                fifo_32_io_o_stream_valid;
  wire       [31:0]   fifo_32_io_o_stream_payload_data;
  wire                fifo_33_io_i_stream_ready;
  wire                fifo_33_io_o_stream_valid;
  wire       [31:0]   fifo_33_io_o_stream_payload_data;
  wire                fifo_34_io_i_stream_ready;
  wire                fifo_34_io_o_stream_valid;
  wire       [31:0]   fifo_34_io_o_stream_payload_data;
  wire                fifo_35_io_i_stream_ready;
  wire                fifo_35_io_o_stream_valid;
  wire       [31:0]   fifo_35_io_o_stream_payload_data;
  wire                fifo_36_io_i_stream_ready;
  wire                fifo_36_io_o_stream_valid;
  wire       [31:0]   fifo_36_io_o_stream_payload_data;
  wire                fifo_37_io_i_stream_ready;
  wire                fifo_37_io_o_stream_valid;
  wire       [31:0]   fifo_37_io_o_stream_payload_data;
  wire                fifo_38_io_i_stream_ready;
  wire                fifo_38_io_o_stream_valid;
  wire       [31:0]   fifo_38_io_o_stream_payload_data;
  wire                fifo_39_io_i_stream_ready;
  wire                fifo_39_io_o_stream_valid;
  wire       [31:0]   fifo_39_io_o_stream_payload_data;
  wire                fifo_40_io_i_stream_ready;
  wire                fifo_40_io_o_stream_valid;
  wire       [31:0]   fifo_40_io_o_stream_payload_data;
  wire                fifo_41_io_i_stream_ready;
  wire                fifo_41_io_o_stream_valid;
  wire       [31:0]   fifo_41_io_o_stream_payload_data;
  wire                fifo_42_io_i_stream_ready;
  wire                fifo_42_io_o_stream_valid;
  wire       [31:0]   fifo_42_io_o_stream_payload_data;
  wire                fifo_43_io_i_stream_ready;
  wire                fifo_43_io_o_stream_valid;
  wire       [31:0]   fifo_43_io_o_stream_payload_data;
  wire                fifo_44_io_i_stream_ready;
  wire                fifo_44_io_o_stream_valid;
  wire       [31:0]   fifo_44_io_o_stream_payload_data;
  wire                fifo_45_io_i_stream_ready;
  wire                fifo_45_io_o_stream_valid;
  wire       [31:0]   fifo_45_io_o_stream_payload_data;
  wire                fifo_46_io_i_stream_ready;
  wire                fifo_46_io_o_stream_valid;
  wire       [31:0]   fifo_46_io_o_stream_payload_data;
  wire                fifo_47_io_i_stream_ready;
  wire                fifo_47_io_o_stream_valid;
  wire       [31:0]   fifo_47_io_o_stream_payload_data;
  wire                fifo_48_io_i_stream_ready;
  wire                fifo_48_io_o_stream_valid;
  wire       [31:0]   fifo_48_io_o_stream_payload_data;
  wire                fifo_49_io_i_stream_ready;
  wire                fifo_49_io_o_stream_valid;
  wire       [31:0]   fifo_49_io_o_stream_payload_data;

  Controller controller_1 (
    .axilite_awvalid       (axilite_awvalid                         ), //i
    .axilite_awready       (controller_1_axilite_awready            ), //o
    .axilite_awaddr        (axilite_awaddr[15:0]                    ), //i
    .axilite_awprot        (axilite_awprot[2:0]                     ), //i
    .axilite_wvalid        (axilite_wvalid                          ), //i
    .axilite_wready        (controller_1_axilite_wready             ), //o
    .axilite_wdata         (axilite_wdata[31:0]                     ), //i
    .axilite_wstrb         (axilite_wstrb[3:0]                      ), //i
    .axilite_bvalid        (controller_1_axilite_bvalid             ), //o
    .axilite_bready        (axilite_bready                          ), //i
    .axilite_bresp         (controller_1_axilite_bresp[1:0]         ), //o
    .axilite_arvalid       (axilite_arvalid                         ), //i
    .axilite_arready       (controller_1_axilite_arready            ), //o
    .axilite_araddr        (axilite_araddr[15:0]                    ), //i
    .axilite_arprot        (axilite_arprot[2:0]                     ), //i
    .axilite_rvalid        (controller_1_axilite_rvalid             ), //o
    .axilite_rready        (axilite_rready                          ), //i
    .axilite_rdata         (controller_1_axilite_rdata[31:0]        ), //o
    .axilite_rresp         (controller_1_axilite_rresp[1:0]         ), //o
    .i_stream_valid        (block_52_io_o_stream_valid              ), //i
    .i_stream_ready        (controller_1_i_stream_ready             ), //o
    .i_stream_payload_data (block_52_io_o_stream_payload_data[31:0] ), //i
    .o_stream_valid        (controller_1_o_stream_valid             ), //o
    .o_stream_ready        (o_stream_ready                          ), //i
    .o_stream_payload_data (controller_1_o_stream_payload_data[31:0]), //o
    .o_stream_payload_last (controller_1_o_stream_payload_last      ), //o
    .signals_N             (controller_1_signals_N[19:0]            ), //o
    .signals_T             (controller_1_signals_T                  ), //o
    .ap_rst_n              (controller_1_ap_rst_n                   ), //o
    .clk                   (clk                                     ), //i
    .resetn                (resetn                                  )  //i
  );
  Block_1 block_27 (
    .io_ap_chain_ap_start     (manager_26_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_26_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_27_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_27_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_27_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (i_stream_valid                         ), //i
    .io_i_stream_ready        (block_27_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (i_stream_payload_data[31:0]            ), //i
    .io_o_stream_valid        (block_27_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_25_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_27_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_2 block_28 (
    .io_ap_chain_ap_start     (manager_27_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_27_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_28_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_28_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_28_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_25_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_28_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_25_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_28_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_26_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_28_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_3 block_29 (
    .io_ap_chain_ap_start     (manager_28_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_28_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_29_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_29_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_29_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_26_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_29_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_26_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_29_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_27_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_29_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_4 block_30 (
    .io_ap_chain_ap_start     (manager_29_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_29_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_30_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_30_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_30_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_27_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_30_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_27_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_30_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_28_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_30_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_5 block_31 (
    .io_ap_chain_ap_start     (manager_30_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_30_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_31_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_31_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_31_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_28_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_31_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_28_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_31_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_29_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_31_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_6 block_32 (
    .io_ap_chain_ap_start     (manager_31_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_31_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_32_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_32_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_32_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_29_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_32_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_29_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_32_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_30_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_32_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_7 block_33 (
    .io_ap_chain_ap_start     (manager_32_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_32_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_33_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_33_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_33_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_30_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_33_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_30_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_33_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_31_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_33_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_8 block_34 (
    .io_ap_chain_ap_start     (manager_33_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_33_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_34_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_34_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_34_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_31_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_34_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_31_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_34_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_32_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_34_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_9 block_35 (
    .io_ap_chain_ap_start     (manager_34_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_34_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_35_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_35_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_35_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_32_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_35_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_32_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_35_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_33_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_35_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_10 block_36 (
    .io_ap_chain_ap_start     (manager_35_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_35_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_36_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_36_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_36_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_33_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_36_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_33_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_36_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_34_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_36_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_11 block_37 (
    .io_ap_chain_ap_start     (manager_36_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_36_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_37_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_37_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_37_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_34_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_37_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_34_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_37_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_35_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_37_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_12 block_38 (
    .io_ap_chain_ap_start     (manager_37_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_37_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_38_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_38_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_38_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_35_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_38_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_35_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_38_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_36_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_38_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_13 block_39 (
    .io_ap_chain_ap_start     (manager_38_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_38_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_39_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_39_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_39_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_36_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_39_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_36_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_39_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_37_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_39_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_14 block_40 (
    .io_ap_chain_ap_start     (manager_39_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_39_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_40_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_40_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_40_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_37_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_40_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_37_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_40_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_38_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_40_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_15 block_41 (
    .io_ap_chain_ap_start     (manager_40_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_40_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_41_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_41_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_41_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_38_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_41_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_38_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_41_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_39_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_41_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_16 block_42 (
    .io_ap_chain_ap_start     (manager_41_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_41_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_42_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_42_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_42_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_39_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_42_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_39_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_42_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_40_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_42_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_17 block_43 (
    .io_ap_chain_ap_start     (manager_42_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_42_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_43_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_43_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_43_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_40_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_43_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_40_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_43_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_41_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_43_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_18 block_44 (
    .io_ap_chain_ap_start     (manager_43_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_43_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_44_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_44_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_44_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_41_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_44_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_41_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_44_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_42_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_44_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_19 block_45 (
    .io_ap_chain_ap_start     (manager_44_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_44_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_45_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_45_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_45_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_42_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_45_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_42_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_45_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_43_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_45_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_20 block_46 (
    .io_ap_chain_ap_start     (manager_45_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_45_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_46_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_46_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_46_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_43_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_46_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_43_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_46_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_44_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_46_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_21 block_47 (
    .io_ap_chain_ap_start     (manager_46_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_46_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_47_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_47_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_47_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_44_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_47_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_44_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_47_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_45_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_47_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_22 block_48 (
    .io_ap_chain_ap_start     (manager_47_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_47_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_48_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_48_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_48_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_45_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_48_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_45_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_48_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_46_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_48_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_23 block_49 (
    .io_ap_chain_ap_start     (manager_48_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_48_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_49_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_49_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_49_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_46_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_49_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_46_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_49_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_47_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_49_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_24 block_50 (
    .io_ap_chain_ap_start     (manager_49_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_49_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_50_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_50_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_50_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_47_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_50_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_47_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_50_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_48_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_50_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_25 block_51 (
    .io_ap_chain_ap_start     (manager_50_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_50_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_51_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_51_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_51_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_48_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_51_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_48_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_51_io_o_stream_valid             ), //o
    .io_o_stream_ready        (fifo_49_io_i_stream_ready              ), //i
    .io_o_stream_payload_data (block_51_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Block_26 block_52 (
    .io_ap_chain_ap_start     (manager_51_ap_chain_ap_start           ), //i
    .io_ap_chain_ap_continue  (manager_51_ap_chain_ap_continue        ), //i
    .io_ap_chain_ap_idle      (block_52_io_ap_chain_ap_idle           ), //o
    .io_ap_chain_ap_ready     (block_52_io_ap_chain_ap_ready          ), //o
    .io_ap_chain_ap_done      (block_52_io_ap_chain_ap_done           ), //o
    .io_i_stream_valid        (fifo_49_io_o_stream_valid              ), //i
    .io_i_stream_ready        (block_52_io_i_stream_ready             ), //o
    .io_i_stream_payload_data (fifo_49_io_o_stream_payload_data[31:0] ), //i
    .io_o_stream_valid        (block_52_io_o_stream_valid             ), //o
    .io_o_stream_ready        (controller_1_i_stream_ready            ), //i
    .io_o_stream_payload_data (block_52_io_o_stream_payload_data[31:0]), //o
    .resetn                   (resetn                                 ), //i
    .clk                      (clk                                    )  //i
  );
  Manager manager_26 (
    .signals_I_N          (controller_1_signals_N[19:0]   ), //i
    .signals_I_T          (controller_1_signals_T         ), //i
    .signals_O_N          (manager_26_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_26_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_26_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_26_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_27_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_27_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_27_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_1 manager_27 (
    .signals_I_N          (manager_26_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_26_signals_O_T         ), //i
    .signals_O_N          (manager_27_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_27_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_27_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_27_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_28_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_28_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_28_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_2 manager_28 (
    .signals_I_N          (manager_27_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_27_signals_O_T         ), //i
    .signals_O_N          (manager_28_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_28_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_28_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_28_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_29_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_29_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_29_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_3 manager_29 (
    .signals_I_N          (manager_28_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_28_signals_O_T         ), //i
    .signals_O_N          (manager_29_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_29_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_29_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_29_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_30_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_30_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_30_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_4 manager_30 (
    .signals_I_N          (manager_29_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_29_signals_O_T         ), //i
    .signals_O_N          (manager_30_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_30_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_30_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_30_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_31_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_31_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_31_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_5 manager_31 (
    .signals_I_N          (manager_30_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_30_signals_O_T         ), //i
    .signals_O_N          (manager_31_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_31_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_31_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_31_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_32_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_32_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_32_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_6 manager_32 (
    .signals_I_N          (manager_31_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_31_signals_O_T         ), //i
    .signals_O_N          (manager_32_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_32_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_32_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_32_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_33_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_33_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_33_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_7 manager_33 (
    .signals_I_N          (manager_32_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_32_signals_O_T         ), //i
    .signals_O_N          (manager_33_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_33_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_33_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_33_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_34_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_34_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_34_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_8 manager_34 (
    .signals_I_N          (manager_33_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_33_signals_O_T         ), //i
    .signals_O_N          (manager_34_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_34_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_34_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_34_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_35_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_35_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_35_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_9 manager_35 (
    .signals_I_N          (manager_34_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_34_signals_O_T         ), //i
    .signals_O_N          (manager_35_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_35_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_35_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_35_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_36_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_36_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_36_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_10 manager_36 (
    .signals_I_N          (manager_35_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_35_signals_O_T         ), //i
    .signals_O_N          (manager_36_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_36_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_36_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_36_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_37_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_37_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_37_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_11 manager_37 (
    .signals_I_N          (manager_36_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_36_signals_O_T         ), //i
    .signals_O_N          (manager_37_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_37_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_37_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_37_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_38_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_38_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_38_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_12 manager_38 (
    .signals_I_N          (manager_37_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_37_signals_O_T         ), //i
    .signals_O_N          (manager_38_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_38_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_38_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_38_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_39_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_39_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_39_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_13 manager_39 (
    .signals_I_N          (manager_38_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_38_signals_O_T         ), //i
    .signals_O_N          (manager_39_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_39_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_39_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_39_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_40_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_40_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_40_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_14 manager_40 (
    .signals_I_N          (manager_39_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_39_signals_O_T         ), //i
    .signals_O_N          (manager_40_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_40_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_40_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_40_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_41_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_41_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_41_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_15 manager_41 (
    .signals_I_N          (manager_40_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_40_signals_O_T         ), //i
    .signals_O_N          (manager_41_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_41_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_41_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_41_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_42_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_42_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_42_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_16 manager_42 (
    .signals_I_N          (manager_41_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_41_signals_O_T         ), //i
    .signals_O_N          (manager_42_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_42_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_42_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_42_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_43_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_43_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_43_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_17 manager_43 (
    .signals_I_N          (manager_42_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_42_signals_O_T         ), //i
    .signals_O_N          (manager_43_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_43_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_43_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_43_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_44_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_44_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_44_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_18 manager_44 (
    .signals_I_N          (manager_43_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_43_signals_O_T         ), //i
    .signals_O_N          (manager_44_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_44_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_44_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_44_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_45_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_45_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_45_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_19 manager_45 (
    .signals_I_N          (manager_44_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_44_signals_O_T         ), //i
    .signals_O_N          (manager_45_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_45_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_45_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_45_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_46_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_46_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_46_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_20 manager_46 (
    .signals_I_N          (manager_45_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_45_signals_O_T         ), //i
    .signals_O_N          (manager_46_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_46_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_46_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_46_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_47_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_47_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_47_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_21 manager_47 (
    .signals_I_N          (manager_46_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_46_signals_O_T         ), //i
    .signals_O_N          (manager_47_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_47_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_47_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_47_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_48_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_48_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_48_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_22 manager_48 (
    .signals_I_N          (manager_47_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_47_signals_O_T         ), //i
    .signals_O_N          (manager_48_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_48_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_48_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_48_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_49_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_49_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_49_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_23 manager_49 (
    .signals_I_N          (manager_48_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_48_signals_O_T         ), //i
    .signals_O_N          (manager_49_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_49_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_49_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_49_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_50_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_50_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_50_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_24 manager_50 (
    .signals_I_N          (manager_49_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_49_signals_O_T         ), //i
    .signals_O_N          (manager_50_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_50_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_50_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_50_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_51_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_51_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_51_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Manager_25 manager_51 (
    .signals_I_N          (manager_50_signals_O_N[19:0]   ), //i
    .signals_I_T          (manager_50_signals_O_T         ), //i
    .signals_O_N          (manager_51_signals_O_N[19:0]   ), //o
    .signals_O_T          (manager_51_signals_O_T         ), //o
    .ap_chain_ap_start    (manager_51_ap_chain_ap_start   ), //o
    .ap_chain_ap_continue (manager_51_ap_chain_ap_continue), //o
    .ap_chain_ap_idle     (block_52_io_ap_chain_ap_idle   ), //i
    .ap_chain_ap_ready    (block_52_io_ap_chain_ap_ready  ), //i
    .ap_chain_ap_done     (block_52_io_ap_chain_ap_done   ), //i
    .clk                  (clk                            ), //i
    .resetn               (resetn                         )  //i
  );
  Fifo fifo_25 (
    .io_i_stream_valid        (block_27_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_25_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_27_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_25_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_28_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_25_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_26 (
    .io_i_stream_valid        (block_28_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_26_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_28_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_26_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_29_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_26_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_27 (
    .io_i_stream_valid        (block_29_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_27_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_29_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_27_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_30_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_27_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_28 (
    .io_i_stream_valid        (block_30_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_28_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_30_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_28_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_31_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_28_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_29 (
    .io_i_stream_valid        (block_31_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_29_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_31_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_29_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_32_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_29_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_30 (
    .io_i_stream_valid        (block_32_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_30_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_32_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_30_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_33_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_30_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_31 (
    .io_i_stream_valid        (block_33_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_31_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_33_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_31_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_34_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_31_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_32 (
    .io_i_stream_valid        (block_34_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_32_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_34_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_32_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_35_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_32_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_33 (
    .io_i_stream_valid        (block_35_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_33_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_35_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_33_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_36_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_33_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_34 (
    .io_i_stream_valid        (block_36_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_34_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_36_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_34_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_37_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_34_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_35 (
    .io_i_stream_valid        (block_37_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_35_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_37_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_35_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_38_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_35_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_36 (
    .io_i_stream_valid        (block_38_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_36_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_38_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_36_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_39_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_36_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_37 (
    .io_i_stream_valid        (block_39_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_37_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_39_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_37_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_40_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_37_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_38 (
    .io_i_stream_valid        (block_40_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_38_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_40_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_38_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_41_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_38_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_39 (
    .io_i_stream_valid        (block_41_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_39_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_41_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_39_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_42_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_39_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_40 (
    .io_i_stream_valid        (block_42_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_40_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_42_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_40_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_43_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_40_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_41 (
    .io_i_stream_valid        (block_43_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_41_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_43_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_41_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_44_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_41_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_42 (
    .io_i_stream_valid        (block_44_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_42_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_44_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_42_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_45_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_42_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_43 (
    .io_i_stream_valid        (block_45_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_43_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_45_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_43_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_46_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_43_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_44 (
    .io_i_stream_valid        (block_46_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_44_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_46_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_44_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_47_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_44_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_45 (
    .io_i_stream_valid        (block_47_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_45_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_47_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_45_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_48_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_45_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_46 (
    .io_i_stream_valid        (block_48_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_46_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_48_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_46_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_49_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_46_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_47 (
    .io_i_stream_valid        (block_49_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_47_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_49_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_47_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_50_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_47_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_48 (
    .io_i_stream_valid        (block_50_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_48_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_50_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_48_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_51_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_48_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  Fifo fifo_49 (
    .io_i_stream_valid        (block_51_io_o_stream_valid             ), //i
    .io_i_stream_ready        (fifo_49_io_i_stream_ready              ), //o
    .io_i_stream_payload_data (block_51_io_o_stream_payload_data[31:0]), //i
    .io_o_stream_valid        (fifo_49_io_o_stream_valid              ), //o
    .io_o_stream_ready        (block_52_io_i_stream_ready             ), //i
    .io_o_stream_payload_data (fifo_49_io_o_stream_payload_data[31:0] ), //o
    .clk                      (clk                                    ), //i
    .resetn                   (resetn                                 )  //i
  );
  assign axilite_awready = controller_1_axilite_awready;
  assign axilite_wready = controller_1_axilite_wready;
  assign axilite_bvalid = controller_1_axilite_bvalid;
  assign axilite_bresp = controller_1_axilite_bresp;
  assign axilite_arready = controller_1_axilite_arready;
  assign axilite_rvalid = controller_1_axilite_rvalid;
  assign axilite_rdata = controller_1_axilite_rdata;
  assign axilite_rresp = controller_1_axilite_rresp;
  assign i_stream_ready = block_27_io_i_stream_ready;
  assign o_stream_valid = controller_1_o_stream_valid;
  assign o_stream_payload_data = controller_1_o_stream_payload_data;
  assign o_stream_payload_last = controller_1_o_stream_payload_last;

endmodule

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

//Fifo replaced by Fifo

module Fifo (
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               clk,
  input               resetn
);

  wire                fifo_25_io_push_ready;
  wire                fifo_25_io_pop_valid;
  wire       [31:0]   fifo_25_io_pop_payload;
  wire       [7:0]    fifo_25_io_occupancy;
  wire       [7:0]    fifo_25_io_availability;

  StreamFifo fifo_25 (
    .io_push_valid   (io_i_stream_valid             ), //i
    .io_push_ready   (fifo_25_io_push_ready         ), //o
    .io_push_payload (io_i_stream_payload_data[31:0]), //i
    .io_pop_valid    (fifo_25_io_pop_valid          ), //o
    .io_pop_ready    (io_o_stream_ready             ), //i
    .io_pop_payload  (fifo_25_io_pop_payload[31:0]  ), //o
    .io_flush        (1'b0                          ), //i
    .io_occupancy    (fifo_25_io_occupancy[7:0]     ), //o
    .io_availability (fifo_25_io_availability[7:0]  ), //o
    .clk             (clk                           ), //i
    .resetn          (resetn                        )  //i
  );
  assign io_i_stream_ready = fifo_25_io_push_ready;
  assign io_o_stream_valid = fifo_25_io_pop_valid;
  assign io_o_stream_payload_data = fifo_25_io_pop_payload;

endmodule

module Manager_25 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_26_BOOT = 2'd0;
  localparam fsm_enumDef_26_s_idle = 2'd1;
  localparam fsm_enumDef_26_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_26_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_26_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_26_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_26_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_26_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_26_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_26_s_idle : begin
      end
      fsm_enumDef_26_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_26_s_idle : begin
      end
      fsm_enumDef_26_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_26_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_26_s_work;
        end
      end
      fsm_enumDef_26_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_26_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_26_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_26_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_26_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_26_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_26_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_24 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_25_BOOT = 2'd0;
  localparam fsm_enumDef_25_s_idle = 2'd1;
  localparam fsm_enumDef_25_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_25_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_25_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_25_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_25_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_25_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_25_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_25_s_idle : begin
      end
      fsm_enumDef_25_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_25_s_idle : begin
      end
      fsm_enumDef_25_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_25_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_25_s_work;
        end
      end
      fsm_enumDef_25_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_25_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_25_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_25_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_25_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_25_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_25_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_23 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_24_BOOT = 2'd0;
  localparam fsm_enumDef_24_s_idle = 2'd1;
  localparam fsm_enumDef_24_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_24_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_24_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_24_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_24_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_24_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_24_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_24_s_idle : begin
      end
      fsm_enumDef_24_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_24_s_idle : begin
      end
      fsm_enumDef_24_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_24_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_24_s_work;
        end
      end
      fsm_enumDef_24_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_24_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_24_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_24_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_24_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_24_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_24_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_22 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_23_BOOT = 2'd0;
  localparam fsm_enumDef_23_s_idle = 2'd1;
  localparam fsm_enumDef_23_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_23_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_23_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_23_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_23_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_23_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_23_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_23_s_idle : begin
      end
      fsm_enumDef_23_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_23_s_idle : begin
      end
      fsm_enumDef_23_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_23_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_23_s_work;
        end
      end
      fsm_enumDef_23_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_23_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_23_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_23_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_23_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_23_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_23_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_21 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_22_BOOT = 2'd0;
  localparam fsm_enumDef_22_s_idle = 2'd1;
  localparam fsm_enumDef_22_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_22_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_22_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_22_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_22_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_22_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_22_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_22_s_idle : begin
      end
      fsm_enumDef_22_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_22_s_idle : begin
      end
      fsm_enumDef_22_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_22_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_22_s_work;
        end
      end
      fsm_enumDef_22_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_22_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_22_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_22_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_22_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_22_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_22_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_20 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_21_BOOT = 2'd0;
  localparam fsm_enumDef_21_s_idle = 2'd1;
  localparam fsm_enumDef_21_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_21_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_21_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_21_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_21_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_21_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_21_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_21_s_idle : begin
      end
      fsm_enumDef_21_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_21_s_idle : begin
      end
      fsm_enumDef_21_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_21_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_21_s_work;
        end
      end
      fsm_enumDef_21_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_21_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_21_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_21_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_21_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_21_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_21_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_19 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_20_BOOT = 2'd0;
  localparam fsm_enumDef_20_s_idle = 2'd1;
  localparam fsm_enumDef_20_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_20_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_20_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_20_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_20_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_20_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_20_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_20_s_idle : begin
      end
      fsm_enumDef_20_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_20_s_idle : begin
      end
      fsm_enumDef_20_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_20_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_20_s_work;
        end
      end
      fsm_enumDef_20_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_20_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_20_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_20_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_20_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_20_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_20_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_18 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_19_BOOT = 2'd0;
  localparam fsm_enumDef_19_s_idle = 2'd1;
  localparam fsm_enumDef_19_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_19_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_19_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_19_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_19_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_19_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_19_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_19_s_idle : begin
      end
      fsm_enumDef_19_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_19_s_idle : begin
      end
      fsm_enumDef_19_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_19_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_19_s_work;
        end
      end
      fsm_enumDef_19_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_19_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_19_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_19_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_19_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_19_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_19_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_17 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_18_BOOT = 2'd0;
  localparam fsm_enumDef_18_s_idle = 2'd1;
  localparam fsm_enumDef_18_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_18_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_18_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_18_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_18_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_18_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_18_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_18_s_idle : begin
      end
      fsm_enumDef_18_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_18_s_idle : begin
      end
      fsm_enumDef_18_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_18_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_18_s_work;
        end
      end
      fsm_enumDef_18_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_18_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_18_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_18_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_18_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_18_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_18_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_16 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_17_BOOT = 2'd0;
  localparam fsm_enumDef_17_s_idle = 2'd1;
  localparam fsm_enumDef_17_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_17_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_17_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_17_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_17_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_17_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_17_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_17_s_idle : begin
      end
      fsm_enumDef_17_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_17_s_idle : begin
      end
      fsm_enumDef_17_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_17_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_17_s_work;
        end
      end
      fsm_enumDef_17_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_17_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_17_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_17_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_17_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_17_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_17_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_15 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_16_BOOT = 2'd0;
  localparam fsm_enumDef_16_s_idle = 2'd1;
  localparam fsm_enumDef_16_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_16_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_16_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_16_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_16_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_16_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_16_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_16_s_idle : begin
      end
      fsm_enumDef_16_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_16_s_idle : begin
      end
      fsm_enumDef_16_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_16_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_16_s_work;
        end
      end
      fsm_enumDef_16_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_16_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_16_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_16_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_16_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_16_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_16_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_14 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_15_BOOT = 2'd0;
  localparam fsm_enumDef_15_s_idle = 2'd1;
  localparam fsm_enumDef_15_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_15_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_15_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_15_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_15_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_15_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_15_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_15_s_idle : begin
      end
      fsm_enumDef_15_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_15_s_idle : begin
      end
      fsm_enumDef_15_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_15_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_15_s_work;
        end
      end
      fsm_enumDef_15_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_15_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_15_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_15_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_15_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_15_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_15_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_13 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_14_BOOT = 2'd0;
  localparam fsm_enumDef_14_s_idle = 2'd1;
  localparam fsm_enumDef_14_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_14_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_14_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_14_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_14_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_14_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_14_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_14_s_idle : begin
      end
      fsm_enumDef_14_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_14_s_idle : begin
      end
      fsm_enumDef_14_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_14_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_14_s_work;
        end
      end
      fsm_enumDef_14_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_14_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_14_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_14_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_14_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_14_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_14_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_12 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_13_BOOT = 2'd0;
  localparam fsm_enumDef_13_s_idle = 2'd1;
  localparam fsm_enumDef_13_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_13_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_13_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_13_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_13_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_13_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_13_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_13_s_idle : begin
      end
      fsm_enumDef_13_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_13_s_idle : begin
      end
      fsm_enumDef_13_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_13_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_13_s_work;
        end
      end
      fsm_enumDef_13_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_13_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_13_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_13_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_13_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_13_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_13_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_11 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_12_BOOT = 2'd0;
  localparam fsm_enumDef_12_s_idle = 2'd1;
  localparam fsm_enumDef_12_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_12_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_12_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_12_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_12_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_12_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_12_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_12_s_idle : begin
      end
      fsm_enumDef_12_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_12_s_idle : begin
      end
      fsm_enumDef_12_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_12_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_12_s_work;
        end
      end
      fsm_enumDef_12_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_12_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_12_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_12_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_12_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_12_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_12_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_10 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_11_BOOT = 2'd0;
  localparam fsm_enumDef_11_s_idle = 2'd1;
  localparam fsm_enumDef_11_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_11_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_11_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_11_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_11_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_11_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_11_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_11_s_idle : begin
      end
      fsm_enumDef_11_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_11_s_idle : begin
      end
      fsm_enumDef_11_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_11_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_11_s_work;
        end
      end
      fsm_enumDef_11_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_11_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_11_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_11_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_11_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_11_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_11_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_9 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_10_BOOT = 2'd0;
  localparam fsm_enumDef_10_s_idle = 2'd1;
  localparam fsm_enumDef_10_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_10_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_10_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_10_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_10_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_10_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_10_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_10_s_idle : begin
      end
      fsm_enumDef_10_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_10_s_idle : begin
      end
      fsm_enumDef_10_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_10_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_10_s_work;
        end
      end
      fsm_enumDef_10_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_10_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_10_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_10_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_10_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_10_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_10_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_8 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_9_BOOT = 2'd0;
  localparam fsm_enumDef_9_s_idle = 2'd1;
  localparam fsm_enumDef_9_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_9_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_9_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_9_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_9_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_9_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_9_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_9_s_idle : begin
      end
      fsm_enumDef_9_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_9_s_idle : begin
      end
      fsm_enumDef_9_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_9_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_9_s_work;
        end
      end
      fsm_enumDef_9_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_9_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_9_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_9_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_9_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_9_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_9_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_7 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_8_BOOT = 2'd0;
  localparam fsm_enumDef_8_s_idle = 2'd1;
  localparam fsm_enumDef_8_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_8_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_8_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_8_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_8_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_8_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_8_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_8_s_idle : begin
      end
      fsm_enumDef_8_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_8_s_idle : begin
      end
      fsm_enumDef_8_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_8_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_8_s_work;
        end
      end
      fsm_enumDef_8_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_8_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_8_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_8_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_8_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_8_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_8_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_6 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_7_BOOT = 2'd0;
  localparam fsm_enumDef_7_s_idle = 2'd1;
  localparam fsm_enumDef_7_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_7_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_7_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_7_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_7_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_7_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_7_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_7_s_idle : begin
      end
      fsm_enumDef_7_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_7_s_idle : begin
      end
      fsm_enumDef_7_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_7_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_7_s_work;
        end
      end
      fsm_enumDef_7_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_7_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_7_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_7_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_7_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_7_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_7_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_5 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_6_BOOT = 2'd0;
  localparam fsm_enumDef_6_s_idle = 2'd1;
  localparam fsm_enumDef_6_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_6_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_6_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_6_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_6_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_6_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_6_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_6_s_idle : begin
      end
      fsm_enumDef_6_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_6_s_idle : begin
      end
      fsm_enumDef_6_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_6_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_6_s_work;
        end
      end
      fsm_enumDef_6_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_6_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_6_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_6_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_6_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_6_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_6_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_4 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_5_BOOT = 2'd0;
  localparam fsm_enumDef_5_s_idle = 2'd1;
  localparam fsm_enumDef_5_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_5_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_5_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_5_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_5_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_5_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_5_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_5_s_idle : begin
      end
      fsm_enumDef_5_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_5_s_idle : begin
      end
      fsm_enumDef_5_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_5_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_5_s_work;
        end
      end
      fsm_enumDef_5_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_5_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_5_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_5_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_5_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_5_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_5_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_3 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_4_BOOT = 2'd0;
  localparam fsm_enumDef_4_s_idle = 2'd1;
  localparam fsm_enumDef_4_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_4_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_4_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_4_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_4_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_4_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_4_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_4_s_idle : begin
      end
      fsm_enumDef_4_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_4_s_idle : begin
      end
      fsm_enumDef_4_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_4_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_4_s_work;
        end
      end
      fsm_enumDef_4_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_4_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_4_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_4_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_4_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_4_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_4_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_2 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_3_BOOT = 2'd0;
  localparam fsm_enumDef_3_s_idle = 2'd1;
  localparam fsm_enumDef_3_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_3_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_3_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_3_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_3_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_3_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_3_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_3_s_idle : begin
      end
      fsm_enumDef_3_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_3_s_idle : begin
      end
      fsm_enumDef_3_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_3_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_3_s_work;
        end
      end
      fsm_enumDef_3_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_3_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_3_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_3_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_3_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_3_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_3_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager_1 (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_2_BOOT = 2'd0;
  localparam fsm_enumDef_2_s_idle = 2'd1;
  localparam fsm_enumDef_2_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_2_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_2_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_2_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_2_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_2_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_2_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_2_s_idle : begin
      end
      fsm_enumDef_2_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_2_s_idle : begin
      end
      fsm_enumDef_2_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_2_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_2_s_work;
        end
      end
      fsm_enumDef_2_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_2_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_2_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_2_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_2_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_2_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_2_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Manager (
  input      [19:0]   signals_I_N,
  input               signals_I_T,
  output     [19:0]   signals_O_N,
  output              signals_O_T,
  output reg          ap_chain_ap_start,
  output              ap_chain_ap_continue,
  input               ap_chain_ap_idle,
  input               ap_chain_ap_ready,
  input               ap_chain_ap_done,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_1_BOOT = 2'd0;
  localparam fsm_enumDef_1_s_idle = 2'd1;
  localparam fsm_enumDef_1_s_work = 2'd2;

  wire       [19:0]   _zz_when_Manager_l78;
  reg        [19:0]   signals_I_N_regNext;
  reg                 signals_I_T_regNext;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Manager_l78;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Manager_l78 = (signals_I_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_1_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_1_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_1_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_1_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_1_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_1_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign signals_O_N = signals_I_N_regNext;
  assign signals_O_T = signals_I_T_regNext;
  assign ap_chain_ap_continue = 1'b1;
  always @(*) begin
    ap_chain_ap_start = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_1_s_idle : begin
      end
      fsm_enumDef_1_s_work : begin
        ap_chain_ap_start = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_1_s_idle : begin
      end
      fsm_enumDef_1_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_1_s_idle : begin
        if(signals_I_T) begin
          fsm_stateNext = fsm_enumDef_1_s_work;
        end
      end
      fsm_enumDef_1_s_work : begin
        if(ap_chain_ap_ready) begin
          if(when_Manager_l78) begin
            fsm_stateNext = fsm_enumDef_1_s_idle;
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_1_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_1_BOOT;
    end
  end

  assign when_Manager_l78 = (fsm_n_counter == _zz_when_Manager_l78);
  always @(posedge clk) begin
    signals_I_N_regNext <= signals_I_N;
    signals_I_T_regNext <= signals_I_T;
    case(fsm_stateReg)
      fsm_enumDef_1_s_idle : begin
        if(signals_I_T) begin
          fsm_n_counter <= 20'h0;
        end
      end
      fsm_enumDef_1_s_work : begin
        if(ap_chain_ap_ready) begin
          if(!when_Manager_l78) begin
            fsm_n_counter <= (fsm_n_counter + 20'h00001);
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_1_BOOT;
    end else begin
      fsm_stateReg <= fsm_stateNext;
    end
  end


endmodule

module Block_26 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  HEAD black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_25 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP11 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_24 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN11 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_23 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP10 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_22 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN10 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_21 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP9 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_20 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN9 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_19 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP8 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_18 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN8 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_17 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP7 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_16 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN7 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_15 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP6 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_14 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN6 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_13 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP5 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_12 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN5 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_11 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP4 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_10 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN4 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_9 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP3 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_8 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN3 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_7 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP2 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_6 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN2 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_5 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP1 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_4 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN1 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_3 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  MLP0 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_2 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  ATTN0 black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Block_1 (
  input               io_ap_chain_ap_start,
  input               io_ap_chain_ap_continue,
  output              io_ap_chain_ap_idle,
  output              io_ap_chain_ap_ready,
  output              io_ap_chain_ap_done,
  input               io_i_stream_valid,
  output              io_i_stream_ready,
  input      [31:0]   io_i_stream_payload_data,
  output              io_o_stream_valid,
  input               io_o_stream_ready,
  output     [31:0]   io_o_stream_payload_data,
  input               resetn,
  input               clk
);

  wire                black_box_ap_done;
  wire                black_box_ap_ready;
  wire                black_box_ap_idle;
  wire                black_box_i_stream_TREADY;
  wire       [31:0]   black_box_o_stream_TDATA;
  wire                black_box_o_stream_TVALID;

  PATCH_EMBED black_box (
    .ap_start        (io_ap_chain_ap_start          ), //i
    .ap_continue     (io_ap_chain_ap_continue       ), //i
    .ap_done         (black_box_ap_done             ), //o
    .ap_ready        (black_box_ap_ready            ), //o
    .ap_idle         (black_box_ap_idle             ), //o
    .i_stream_TDATA  (io_i_stream_payload_data[31:0]), //i
    .i_stream_TREADY (black_box_i_stream_TREADY     ), //o
    .i_stream_TVALID (io_i_stream_valid             ), //i
    .o_stream_TDATA  (black_box_o_stream_TDATA[31:0]), //o
    .o_stream_TREADY (io_o_stream_ready             ), //i
    .o_stream_TVALID (black_box_o_stream_TVALID     ), //o
    .ap_clk          (clk                           ), //i
    .ap_rst_n        (resetn                        )  //i
  );
  assign io_ap_chain_ap_done = black_box_ap_done;
  assign io_ap_chain_ap_ready = black_box_ap_ready;
  assign io_ap_chain_ap_idle = black_box_ap_idle;
  assign io_i_stream_ready = black_box_i_stream_TREADY;
  assign io_o_stream_payload_data = black_box_o_stream_TDATA;
  assign io_o_stream_valid = black_box_o_stream_TVALID;

endmodule

module Controller (
  input               axilite_awvalid,
  output              axilite_awready,
  input      [15:0]   axilite_awaddr,
  input      [2:0]    axilite_awprot,
  input               axilite_wvalid,
  output              axilite_wready,
  input      [31:0]   axilite_wdata,
  input      [3:0]    axilite_wstrb,
  output              axilite_bvalid,
  input               axilite_bready,
  output     [1:0]    axilite_bresp,
  input               axilite_arvalid,
  output reg          axilite_arready,
  input      [15:0]   axilite_araddr,
  input      [2:0]    axilite_arprot,
  output              axilite_rvalid,
  input               axilite_rready,
  output     [31:0]   axilite_rdata,
  output     [1:0]    axilite_rresp,
  input               i_stream_valid,
  output reg          i_stream_ready,
  input      [31:0]   i_stream_payload_data,
  output reg          o_stream_valid,
  input               o_stream_ready,
  output reg [31:0]   o_stream_payload_data,
  output reg          o_stream_payload_last,
  output     [19:0]   signals_N,
  output reg          signals_T,
  output              ap_rst_n,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_BOOT = 2'd0;
  localparam fsm_enumDef_s_idle = 2'd1;
  localparam fsm_enumDef_s_work = 2'd2;

  wire       [19:0]   _zz_when_Controller_l92;
  wire                busCtrl_readHaltRequest;
  wire                busCtrl_writeHaltRequest;
  wire                busCtrl_writeJoinEvent_valid;
  wire                busCtrl_writeJoinEvent_ready;
  wire                busCtrl_writeJoinEvent_fire;
  wire       [1:0]    busCtrl_writeRsp_resp;
  wire                busCtrl_writeJoinEvent_translated_valid;
  wire                busCtrl_writeJoinEvent_translated_ready;
  wire       [1:0]    busCtrl_writeJoinEvent_translated_payload_resp;
  wire                _zz_axilite_bvalid;
  reg                 _zz_busCtrl_writeJoinEvent_translated_ready;
  wire                _zz_axilite_bvalid_1;
  reg                 _zz_axilite_bvalid_2;
  reg        [1:0]    _zz_axilite_bresp;
  wire                when_Stream_l368;
  wire                busCtrl_readDataStage_valid;
  wire                busCtrl_readDataStage_ready;
  wire       [15:0]   busCtrl_readDataStage_payload_addr;
  wire       [2:0]    busCtrl_readDataStage_payload_prot;
  reg                 axilite_ar_rValid;
  reg        [15:0]   axilite_ar_rData_addr;
  reg        [2:0]    axilite_ar_rData_prot;
  wire                when_Stream_l368_1;
  wire       [31:0]   busCtrl_readRsp_data;
  wire       [1:0]    busCtrl_readRsp_resp;
  wire                _zz_axilite_rvalid;
  wire       [15:0]   busCtrl_readAddressMasked;
  wire       [15:0]   busCtrl_writeAddressMasked;
  wire                busCtrl_writeOccur;
  wire                busCtrl_readOccur;
  reg        [19:0]   _zz_signals_N;
  reg                 _zz_ap_rst_n;
  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [19:0]   fsm_n_counter;
  reg        [9:0]    fsm_trip_counter;
  reg        [1:0]    fsm_stateReg;
  reg        [1:0]    fsm_stateNext;
  wire                when_Controller_l92;
  wire                when_Controller_l90;
  wire                i_stream_fire;
  `ifndef SYNTHESIS
  reg [47:0] fsm_stateReg_string;
  reg [47:0] fsm_stateNext_string;
  `endif


  assign _zz_when_Controller_l92 = (signals_N - 20'h00001);
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_BOOT : fsm_stateReg_string = "BOOT  ";
      fsm_enumDef_s_idle : fsm_stateReg_string = "s_idle";
      fsm_enumDef_s_work : fsm_stateReg_string = "s_work";
      default : fsm_stateReg_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_BOOT : fsm_stateNext_string = "BOOT  ";
      fsm_enumDef_s_idle : fsm_stateNext_string = "s_idle";
      fsm_enumDef_s_work : fsm_stateNext_string = "s_work";
      default : fsm_stateNext_string = "??????";
    endcase
  end
  `endif

  assign busCtrl_readHaltRequest = 1'b0;
  assign busCtrl_writeHaltRequest = 1'b0;
  assign busCtrl_writeJoinEvent_fire = (busCtrl_writeJoinEvent_valid && busCtrl_writeJoinEvent_ready);
  assign busCtrl_writeJoinEvent_valid = (axilite_awvalid && axilite_wvalid);
  assign axilite_awready = busCtrl_writeJoinEvent_fire;
  assign axilite_wready = busCtrl_writeJoinEvent_fire;
  assign busCtrl_writeJoinEvent_translated_valid = busCtrl_writeJoinEvent_valid;
  assign busCtrl_writeJoinEvent_ready = busCtrl_writeJoinEvent_translated_ready;
  assign busCtrl_writeJoinEvent_translated_payload_resp = busCtrl_writeRsp_resp;
  assign _zz_axilite_bvalid = (! busCtrl_writeHaltRequest);
  assign busCtrl_writeJoinEvent_translated_ready = (_zz_busCtrl_writeJoinEvent_translated_ready && _zz_axilite_bvalid);
  always @(*) begin
    _zz_busCtrl_writeJoinEvent_translated_ready = axilite_bready;
    if(when_Stream_l368) begin
      _zz_busCtrl_writeJoinEvent_translated_ready = 1'b1;
    end
  end

  assign when_Stream_l368 = (! _zz_axilite_bvalid_1);
  assign _zz_axilite_bvalid_1 = _zz_axilite_bvalid_2;
  assign axilite_bvalid = _zz_axilite_bvalid_1;
  assign axilite_bresp = _zz_axilite_bresp;
  always @(*) begin
    axilite_arready = busCtrl_readDataStage_ready;
    if(when_Stream_l368_1) begin
      axilite_arready = 1'b1;
    end
  end

  assign when_Stream_l368_1 = (! busCtrl_readDataStage_valid);
  assign busCtrl_readDataStage_valid = axilite_ar_rValid;
  assign busCtrl_readDataStage_payload_addr = axilite_ar_rData_addr;
  assign busCtrl_readDataStage_payload_prot = axilite_ar_rData_prot;
  assign _zz_axilite_rvalid = (! busCtrl_readHaltRequest);
  assign busCtrl_readDataStage_ready = (axilite_rready && _zz_axilite_rvalid);
  assign axilite_rvalid = (busCtrl_readDataStage_valid && _zz_axilite_rvalid);
  assign axilite_rdata = busCtrl_readRsp_data;
  assign axilite_rresp = busCtrl_readRsp_resp;
  assign busCtrl_writeRsp_resp = 2'b00;
  assign busCtrl_readRsp_resp = 2'b00;
  assign busCtrl_readRsp_data = 32'h0;
  assign busCtrl_readAddressMasked = (busCtrl_readDataStage_payload_addr & (~ 16'h0003));
  assign busCtrl_writeAddressMasked = (axilite_awaddr & (~ 16'h0003));
  assign busCtrl_writeOccur = (busCtrl_writeJoinEvent_valid && busCtrl_writeJoinEvent_ready);
  assign busCtrl_readOccur = (axilite_rvalid && axilite_rready);
  always @(*) begin
    signals_T = 1'b0;
    case(busCtrl_writeAddressMasked)
      16'h0010 : begin
        if(busCtrl_writeOccur) begin
          signals_T = axilite_wdata[0];
        end
      end
      default : begin
      end
    endcase
  end

  assign signals_N = _zz_signals_N;
  assign ap_rst_n = _zz_ap_rst_n;
  always @(*) begin
    i_stream_ready = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_s_idle : begin
      end
      fsm_enumDef_s_work : begin
        i_stream_ready = o_stream_ready;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    o_stream_valid = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_s_idle : begin
      end
      fsm_enumDef_s_work : begin
        o_stream_valid = i_stream_valid;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    o_stream_payload_last = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_s_idle : begin
      end
      fsm_enumDef_s_work : begin
        o_stream_payload_last = (when_Controller_l90 && when_Controller_l92);
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    o_stream_payload_data = 32'h0;
    case(fsm_stateReg)
      fsm_enumDef_s_idle : begin
      end
      fsm_enumDef_s_work : begin
        o_stream_payload_data = i_stream_payload_data;
      end
      default : begin
      end
    endcase
  end

  assign fsm_wantExit = 1'b0;
  always @(*) begin
    fsm_wantStart = 1'b0;
    case(fsm_stateReg)
      fsm_enumDef_s_idle : begin
      end
      fsm_enumDef_s_work : begin
      end
      default : begin
        fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign fsm_wantKill = 1'b0;
  always @(*) begin
    fsm_stateNext = fsm_stateReg;
    case(fsm_stateReg)
      fsm_enumDef_s_idle : begin
        if(signals_T) begin
          fsm_stateNext = fsm_enumDef_s_work;
        end
      end
      fsm_enumDef_s_work : begin
        if(i_stream_fire) begin
          if(when_Controller_l90) begin
            if(when_Controller_l92) begin
              fsm_stateNext = fsm_enumDef_s_idle;
            end
          end
        end
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_s_idle;
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_BOOT;
    end
  end

  assign when_Controller_l92 = (fsm_n_counter == _zz_when_Controller_l92);
  assign when_Controller_l90 = (fsm_trip_counter == 10'h3e7);
  assign i_stream_fire = (i_stream_valid && i_stream_ready);
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      _zz_axilite_bvalid_2 <= 1'b0;
      axilite_ar_rValid <= 1'b0;
      fsm_stateReg <= fsm_enumDef_BOOT;
    end else begin
      if(_zz_busCtrl_writeJoinEvent_translated_ready) begin
        _zz_axilite_bvalid_2 <= (busCtrl_writeJoinEvent_translated_valid && _zz_axilite_bvalid);
      end
      if(axilite_arready) begin
        axilite_ar_rValid <= axilite_arvalid;
      end
      fsm_stateReg <= fsm_stateNext;
    end
  end

  always @(posedge clk) begin
    if(_zz_busCtrl_writeJoinEvent_translated_ready) begin
      _zz_axilite_bresp <= busCtrl_writeJoinEvent_translated_payload_resp;
    end
    if(axilite_arready) begin
      axilite_ar_rData_addr <= axilite_araddr;
      axilite_ar_rData_prot <= axilite_arprot;
    end
    case(busCtrl_writeAddressMasked)
      16'h0 : begin
        if(busCtrl_writeOccur) begin
          _zz_signals_N <= axilite_wdata[19 : 0];
        end
      end
      16'h0020 : begin
        if(busCtrl_writeOccur) begin
          _zz_ap_rst_n <= axilite_wdata[0];
        end
      end
      default : begin
      end
    endcase
    case(fsm_stateReg)
      fsm_enumDef_s_idle : begin
        if(signals_T) begin
          fsm_n_counter <= 20'h0;
          fsm_trip_counter <= 10'h0;
        end
      end
      fsm_enumDef_s_work : begin
        if(i_stream_fire) begin
          if(when_Controller_l90) begin
            fsm_trip_counter <= 10'h0;
            if(!when_Controller_l92) begin
              fsm_n_counter <= (fsm_n_counter + 20'h00001);
            end
          end else begin
            fsm_trip_counter <= (fsm_trip_counter + 10'h001);
          end
        end
      end
      default : begin
      end
    endcase
  end


endmodule

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

//StreamFifo replaced by StreamFifo

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [31:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [31:0]   io_pop_payload,
  input               io_flush,
  output     [7:0]    io_occupancy,
  output     [7:0]    io_availability,
  input               clk,
  input               resetn
);

  reg        [31:0]   _zz_logic_ram_port0;
  wire       [6:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [6:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [6:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [6:0]    logic_pushPtr_valueNext;
  reg        [6:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [6:0]    logic_popPtr_valueNext;
  reg        [6:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1078;
  wire       [6:0]    logic_ptrDif;
  reg [31:0] logic_ram [0:127];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {6'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {6'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 7'h7f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 7'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 7'h7f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 7'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1078 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      logic_pushPtr_value <= 7'h0;
      logic_popPtr_value <= 7'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1078) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule
