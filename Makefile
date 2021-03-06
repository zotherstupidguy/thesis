.PHONY: stats

split-intransitivity-arawak.pdf: main.tex title.tex bib/references.bib bib/lsalike.bst chapter1/chapter.tex chapter2/chapter.tex chapter3/chapter.tex chapter4/chapter.tex
  # some Latex preprocessing
	# fix Mendeley Bibtex output
	sed -i 's/S\\o ren/S{\\o}ren/g' bib/references.bib

	# turn Sa, Sp, etc. into subscripted variant 
	sed -i -r 's/\<S(A|P|O|io)\>/S\\textsubscript{\1}/g' chapter*/chapter.tex
	# also SaV and VSp
	sed -i -r 's/\<SAV\>/S\\textsubscript{A}V/g' chapter*/chapter.tex
	sed -i -r 's/\<VSP\>/VS\\textsubscript{P}/g' chapter*/chapter.tex
	# exclude citations from list of tables
	sed -i -r 's/(\\caption)(\{(.+) (~?\\citep(\[.+\])?\{.+\})\})/\1\[\3\]\2/g' chapter*/chapter.tex
	# remove stupid space before citations
	sed -i -r 's/~\\citep/\\citep/g' chapter*/chapter.tex

  # compile
	latexmk -xelatex main.tex

	# rename
	mv main.pdf split-intransitivity-arawak.pdf

chapter%/chapter.tex: chapter%/chapter.mmd
	multimarkdown -t latex -b $<

clean:
	rm -f main.aux main.fdb_latexmk main.fls main.log main.lot main.out main.pdf main.toc chapter1/chapter.tex chapter2/chapter.tex chapter3/chapter.tex chapter4/chapter.tex

stats: split-intransitivity-arawak.pdf
	@echo `pdfinfo split-intransitivity-arawak.pdf | grep Pages`
	@echo `pdftotext split-intransitivity-arawak.pdf - | wc -l` lines
	@echo `pdftotext split-intransitivity-arawak.pdf - | wc -w` words
	@echo `pdftotext split-intransitivity-arawak.pdf - | wc -m` characters

open: split-intransitivity-arawak.pdf
	acroread split-intransitivity-arawak.pdf
