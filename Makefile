OBJS=metlib4.o oclablas.o ocnum.o gtp3.o matsmin.o lmdif1lib.o smp2.o pmon6.o
EXE=oc4A

all: $(EXE)


pmain1.F90: linkocdate.F90
	gfortran -O2 -o linkoc linkocdate.F90
	./linkoc

metlib4.o:	utilities/metlib4.F90
	# copy getkey module information
	cp utilities/GETKEY/m_getkey.mod .
	gfortran -c utilities/metlib4.F90

oclablas.o:	numlib/oclablas.F90
	gfortran -c numlib/oclablas.F90

ocnum.o:	numlib/ocnum.F90
	gfortran -c numlib/ocnum.F90

lmdif1lib.o:      numlib/lmdif1lib.F90
	gfortran -c numlib/lmdif1lib.F90

gtp3.o:	models/gtp3.F90
	gfortran -c models/gtp3.F90

matsmin.o:	minimizer/matsmin.F90
	gfortran -c minimizer/matsmin.F90

smp2.o:		stepmapplot/smp2.F90
	gfortran -c stepmapplot/smp2.F90

pmon6.o:	userif/pmon6.F90
	gfortran -c userif/pmon6.F90

$(EXE): $(OBJS) pmain1.F90
	# liboceq.a
	ar sq liboceq.a metlib4.o oclablas.o ocnum.o gtp3.o matsmin.o lmdif1lib.o
	# insert date of linking
	gfortran -O2 -o linkoc linkocdate.F90
	./linkoc

	# link without getkey
	#	gfortran -o $(EXE) pmain1.F90 pmon6.o smp2.o liboceq.a

	# copy getkey.o and link with getkey
	cp utilities/GETKEY/getkey.o .
	gfortran -o $(EXE) pmain1.F90 pmon6.o smp2.o liboceq.a getkey.o

clean:
	rm -r *.o *.mod linkoc liboceq.a oc4A
