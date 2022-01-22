OUTPUTDIRECTORY="output/"

all: init pdf mv

init:
	@mkdir -p ${OUTPUTDIRECTORY}
	@echo "------------------------------------------------------------"
	@echo "Creating identitical directory layout in: ${OUTPUTDIRECTORY}"
	@echo "------------------------------------------------------------"
	@for DIR in $(shell find . -maxdepth 1 -mindepth 1 -type d -exec basename '{}' \;) ; do \
		mkdir -p ${OUTPUTDIRECTORY}/$$DIR ; \
	done

pdf:
	@echo "------------------------------------------------------------"
	@echo "Building project..."
	@echo "Output directory: ${OUTPUTDIRECTORY}"
	@echo "------------------------------------------------------------"
	xelatex -output-directory=output -shell-escape thesis.tex

mv:
	@echo "------------------------------------------------------------"
	@echo "Copying PDF into root"
	@echo "------------------------------------------------------------"
	@cp output/thesis.pdf . | true
