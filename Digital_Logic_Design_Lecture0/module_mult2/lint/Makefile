01 run_lint:
	spyglass -project proName.prj -goals  lint/lint_rtl -batch

02 copy_rpt:
	#gtar -cvzf lint_rpt.tgz ./proName/consolidated_reports/mult2_lint_lint_rtl/
	cp ./proName/consolidated_reports/mult2_lint_lint_rtl/moresimple.rpt lint_summary.log
	./grep_log

90 clean:
	\rm -rf proName
	\rm -rf WORK
	\rm -rf *.log
	\rm -rf *.rpt
	\rm -rf *.out
	\rm -rf *.tgz
	

