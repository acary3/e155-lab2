`timescale 1 ns/10 ps

// scan_gen_tb.sv
// Automatic testbench for scan_gen. Small parameters used so the full
// 4-state cycle happens in a handful of clock edges

module tb_scan_gen();

    logic clk, reset, en;
    logic [3:0] row;

    scan_gen #(.W0(2), .W1(3), .M0(1)) dut (
        .clk(clk), .reset(reset), .en(en), .row(row)
    );

    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        // reset test
        reset = 1; en = 0;
        @(posedge clk);
        @(posedge clk); #1;
        assert(row == 4'b1000) else $error("reset did not force row to 1000");

        // enable test, row should hold while disabled
        reset = 0;
        repeat (4) @(posedge clk); #1;
        assert(row == 4'b1000) else $error("row moved while disabled");

        // enable and check all four states in order
        en = 1;
        @(posedge clk); @(posedge clk); #1;
        assert(row == 4'b0100) else $error("state 1 wrong, row=%b", row);

        @(posedge clk); @(posedge clk); #1;
        assert(row == 4'b0010) else $error("state 2 wrong, row=%b", row);

        @(posedge clk); @(posedge clk); #1;
        assert(row == 4'b0001) else $error("state 3 wrong, row=%b", row);

        // reset in the middle of scanning
        reset = 1;
        @(posedge clk); #1;
        assert(row == 4'b1000) else $error("mid scan reset failed, row=%b", row);
        reset = 0;

        $display("tb_scan_gen: all checks passed");
        $finish;
    end

    initial begin
        #2000;
        $error("tb_scan_gen: timeout, simulation did not finish");
        $finish;
    end

endmodule
