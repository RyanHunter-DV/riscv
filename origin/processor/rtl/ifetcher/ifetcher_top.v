module ifetcher_top(
	iClk,
	iResetn,
	fromCache_resp,
	fromCache_instr,
	toCache_req,
	toCache_pc
); // {


	ifetcher_pcCtrl pcCtrl(
		.iClk    (iClk),
		.iResetn (iResetn),
		.iJumpVld(),
		.iJumpPC (),
		.iNext   (),
		.oPC     ()
	);

	ifetcher_cachePort cachePort(
		.iClk           (),
		.iResetn        (),
		.fromCache_resp (),
		.fromCache_instr(),
		.toCache_req    (),
		.toCache_pc     (),
		.iRcvFifoFull   (),
		.oRcvFifoWE     (),
		.oRcvFifoWD     (),
		.oNext          (),
		.iPC            (),
		.oCountDone     (),
		.oCountEn       ()
	);

	ifetcher_jumpReset jumpReset(
		.iClk    (),
		.iResetn (),
		.iJumpVld(),
		.iCounter(),
		.oClear  ()
	);

	ifetcher_timeoutCounter timeoutCunter(
		.iClk         (),
		.iResetn      (),
		.iCountEn     (),
		.iCountDone   (),
		.oTimeoutFatal(),
		.oCounter     ()
	);

	ifetcher_rcvdb rcvdb(
		.iClk   (),
		.iResetn(),
		.iClear (),
		.iWE    (),
		.iWD    (),
		.iRE    (),
		.oRD    (),
		.oEmpty (),
		.oFull  ()
	);

endmodule // }