`timescale 1 ns/10 ps

module HSOSC #(parameter CLKHF_DIV = "0b00") (
    input  logic CLKHFEN,
    input  logic CLKHFPU,
    output logic CLKHF
);
    initial begin
        CLKHF = 0;
        wait (CLKHFEN && CLKHFPU);
        #50;
        forever #10.417 CLKHF = ~CLKHF;
    end
endmodule

// tb_lab2_ac.sv
// Automatic testbench for lab2_ac. Small counter parameters are used so
// the multiplexing toggles quickly in simulation.

module tb_lab2_ac();

    logic reset;
    logic [3:0] sw0, sw1, col;
    logic [3:0] row, led;
    logic [6:0] seg;
    logic [1:0] an;

    lab2_ac #(
        .MUX_W(3), .MUX_MAX(3),
        .SCAN_W0(2), .SCAN_W1(3), .SCAN_M0(1)
    ) dut (
        .reset(reset), .sw0(sw0), .sw1(sw1), .col(col),
        .row(row), .led(led), .seg(seg), .an(an)
    );

    initial begin
        reset = 1; sw0 = 4'h5; sw1 = 4'hA; col = 4'hF;
        #200; // let HSOSC start up and hold reset a while
        @(posedge dut.clk);
        reset = 0;

        // digit 0 should be shown first, sel starts low after reset
        @(negedge dut.clk);
        assert(seg == 7'b0100100) else $error("seg for sw0 wrong, seg=%b", seg);
        assert(an  == 2'b10)      else $error("an for digit0 wrong, an=%b", an);

        // wait for the mux counter to switch digits
        wait (dut.sel == 1'b1);
        @(negedge dut.clk);
        assert(seg == 7'b0001000) else $error("seg for sw1 wrong, seg=%b", seg);
        assert(an  == 2'b01)      else $error("an for digit1 wrong, an=%b", an);

        // keypad passthrough check
        col = 4'b1011;
        #20;
        assert(led == ~col) else $error("led passthrough wrong, led=%b", led);

        $display("tb_lab2_ac: all checks passed");
        $finish;
    end

    initial begin
        #100000;
        $error("tb_lab2_ac: timeout, simulation did not finish");
        $finish;
    end

endmodule
