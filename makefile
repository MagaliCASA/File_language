CAMLC=$(BINDIR)ocamlc
CAMLDEP=$(BINDIR)ocamldep
CAMLLEX=$(BINDIR)ocamllex
CAMLYACC=$(BINDIR)ocamlyacc
# COMPFLAGS=-w A-4-6-9 -warn-error A -g
COMPFLAGS=-I /Users/mag3labest/.opam/default/lib/ocaml/unix
CAML_B_LFLAGS = /Users/mag3labest/.opam/default/lib/ocaml/unix/unix.cma

EXEC = pcfloop

# Fichiers compilés, à produire pour fabriquer l'exécutable
SOURCES = executeur_final.ml pcfast.ml pcfsem.ml pcfloop.ml 
GENERATED = pcflex.ml pcfparse.ml pcfparse.mli
MLIS =
OBJS = $(GENERATED:.ml=.cmo) $(SOURCES:.ml=.cmo)

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CAMLC) $(CAML_B_LFLAGS) $(COMPFLAGS) $(OBJS) -o $(EXEC)

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx
.SUFFIXES: .mll .mly

.ml.cmo:
	$(CAMLC) $(COMPFLAGS) -c $<

.mli.cmi:
	$(CAMLC) $(COMPFLAGS) -c $<

.mll.ml:
	$(CAMLLEX) $<

.mly.ml:
	$(CAMLYACC) $<

# Clean up
clean:
	rm -f *.cm[io] *.cmx *~ .*~ *.o
	rm -f parser.mli
	rm -f $(GENERATED)
	rm -f $(EXEC)
	rm -f tarball-enonce.tgz tarball-solution.tgz

# Dependencies
depend: $(SOURCES) $(GENERATED) $(MLIS)
	$(CAMLDEP) $(SOURCES) $(GENERATED) $(MLIS) > .depend

include .depend
