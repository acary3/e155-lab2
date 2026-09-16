`timescale 1 ns/10 ps

// lab2_ac.sv
// Arthur Cary, acary@hmc.edu
// September 16, 2026
// Top module for lab 2. Drives a multiplexed dual seven-segment display
// and reads a 4x4 keypad through a scanning circuit.

module lab2_ac #(
    parameter MUX_W   = 15,
    parameter MUX_MAX = 24000,
    parameter SCAN_W0 = 23,
    parameter SCAN_W1 = 24,
    parameter SCAN_M0 = 6000000
) (
    input  logic reset,
    input  logic [3:0] sw0,
    input  logic [3:0] sw1,
    input  logic [3:0] col,
    output logic [3:0] row,
    output logic [3:0] led,
    output logic [6:0] seg,
    output logic [1:0] an
);

    logic clk;
    logic sel;
    logic [3:0] hex;

    HSOSC #(.CLKHF_DIV("0b00")) osc (
        .CLKHFEN(1'b1),
        .CLKHFPU(1'b1),
        .CLKHF(clk)
    );

    blinker #(.WIDTH(MUX_W), .MAX_COUNT(MUX_MAX)) mux_cnt (
        .clk(clk), .reset(reset), .en(1'b1), .blink(sel)
    );

    scan_gen #(.W0(SCAN_W0), .W1(SCAN_W1), .M0(SCAN_M0)) scan (
        .clk(clk), .reset(reset), .en(1'b1), .row(row)
    );

    decoder dec (.s(hex), .seg(seg));

    assign hex   = sel ? sw1 : sw0; // multiplexing passthrough
    assign an[0] = sel;          
    assign an[1] = ~sel;

    assign led = ~col; // scanning passthrough, cols pulled up

endmodule
