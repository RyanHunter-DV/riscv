module ifetcher_top #(PCW=32,IW=32,CW=8) (
	iClk,
	iResetn,
	fromCache_resp,
	fromCache_instr,
	toCache_req,
	toCache_pc,
	// jump info
	iJumpVld,
	iJumpPC,
	// fromDec
	fromDec_RE,
	toDec_RD,
	toDec_empty,
	// timeout
	oTimeoutFatal
); // {

	input iJumpVld;
	input [PCW-1:0] iJumpPC;
	input [IW*4-1:0] fromCache_instr;
	input fromDec_RE;

	output toCache_req;
	output [PCW-1:0] toCache_pc;
	output oTimeoutFatal;
	output [IW*4-1:0] toDec_RD;
	output toDec_empty;

	wire wNext;
	wire [PCW-1:0] wPC;
	wire wRcvFifoFull,wRcvFifoWE;
	wire [IW*4-1:0] wRcvFifoWD;
	wire wCountDone,wCountEn;
	wire [CW-1:0] wCounter;
	wire wClear;

	ifetcher_pcCtrl #(PCW) pcCtrl(
		.iClk    (iClk),
		.iResetn (iResetn),
		.iJumpVld(iJumpVld),
		.iJumpPC (iJumpPC),
		.iNext   (wNext),
		.oPC     (wPC)
	);

	ifetcher_cachePort #PCW,IW) cachePort(
		.iClk           (iClk),
		.iResetn        (iResetn),
		.fromCache_resp (fromCache_resp),
		.fromCache_instr(fromCache_instr),
		.toCache_req    (toCache_req),
		.toCache_pc     (toCache_pc),
		.iRcvFifoFull   (wRcvFifoFull),
		.oRcvFifoWE     (wRcvFifoWE),
		.oRcvFifoWD     (wRcvFifoWD),
		.oNext          (wNext),
		.iPC            (wPC),
		.oCountDone     (wCountDone),
		.oCountEn       (wCountEn)
	);

	ifetcher_jumpReset #(CW) jumpReset(
		.iClk    (iClk),
		.iResetn (iResetn),
		.iJumpVld(iJumpVld),
		.iCounter(wCounter),
		.oClear  (wClear)
	);

	ifetcher_timeoutCounter #(CW) timeoutCunter(
		.iClk         (iClk),
		.iResetn      (iResetn),
		.iCountEn     (wCountEn),
		.iCountDone   (wCountDone),
		.oTimeoutFatal(oTimeoutFatal),
		.oCounter     (wCounter)
	);

	ifetcher_rcvdb #(IW) rcvdb(
		.iClk   (iClk),
		.iResetn(iResetn),
		.iClear (wClear),
		.iWE    (wRcvFifoWE),
		.iWD    (wRcvFifoWD),
		.iRE    (fromDec_RE),
		.oRD    (toDec_RD),
		.oEmpty (toDec_empty),
		.oFull  (wRcvFifoFull)
	);

endmodule // }
