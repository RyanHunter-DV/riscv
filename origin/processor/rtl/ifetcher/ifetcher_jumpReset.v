module ifetcher_jumpReset #(CW=8) (
	iClk,
	iResetn,
	iJumpVld,
	iCounter,
	oClear
);

	input iClk,iResetn;
	input iJumpVld;
	input [CW-1:0] iCounter;
	output oClear;
	reg rClear;
	reg jumpVld_hold;
	wire outstanding;


	assign outstanding = (|iCounter)? 1'b1:1'b0;
	assign oClear=rClear;
	always @(posedge iClk or negedge iResetn) begin
		if (!iResetn) begin
			rClear<=1'b0;
			jumpVld_hold<=1'b0;
		end else begin
			// logic of jumpVld_hold
			if (iJumpVld)
				jumpVld_hold<=1'b1;
			else if (rClear)
				jumpVld_hold<=1'b0;
			// logic of rClear
			if (jumpVld_hold&!outstanding) rClear<=1'b1;
			if (rClear) rClear<=1'b0; // rClear only lasts 1 cycle
		end
	end


endmodule