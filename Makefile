all:
	/home/shevek/src/render-openscad/render-openscad < minerva_renderer.scad

dxf: build/hexagon.dxf build/h_boards.dxf build/v_boards.dxf build/tierod.dxf


%.eps: %-prepared.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -dt -f dxf:-polyaslines\ -mm $< $@

.PHONY: all dxf
