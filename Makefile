all: parts plates extruder

parts:
	/home/shevek/src/render-openscad/render-openscad < minerva_renderer.scad

plates:
	/home/shevek/src/render-openscad/render-openscad --part=plate < minerva_renderer.scad

extruder:
	/home/shevek/src/render-openscad/render-openscad < extruder_drive_renderer.scad

dxf: build/wood-hexagon-1x.dxf build/wood-h_boards-1x.dxf build/wood-v_boards-1x.dxf


%.eps: %-prepared.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -psarg -dREALLYDELAYBIND -dt -f dxf_s:-mm $< $@

.PHONY: all dxf
