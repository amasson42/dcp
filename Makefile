
all: Dcpmaker
	./Dcpmaker -help

.PHONY: Dcpmaker
Dcpmaker:
	@cd Dcpmaker_srcs && swift build && cp .build/debug/Dcpmaker ../Dcpmaker

.PHONY: clean
clean:
	cd Dcpmaker_srcs && swift package clean

.PHONY: fclean
fclean: clean
	cd Dcpmaker_srcs && swift package reset
	rm -f Dcpmaker
	rm -rf workspace

.PHONY: re
re: fclean all
