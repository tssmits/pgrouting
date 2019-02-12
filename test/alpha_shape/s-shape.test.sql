CREATE TABLE s_test(geom geometry);

INSERT INTO s_test(geom) VALUES(ST_GeomFromText('MULTIPOINT(
(120 -224), (185 -219), (190 -234), (200 -246), (212 -256), (227 -261),
(242 -264), (257 -265), (272 -264), (287 -263),(302 -258), (315 -250),
(323 -237), (321 -222), (308 -213), (293 -208), (278 -205), (263 -202),
(248 -199), (233 -196), (218 -193), (203 -190), (188 -185), (173 -180),
(160 -172), (148 -162), (138 -150), (133 -135), (132 -120), (136 -105),
(146  -92), (158  -82), (171  -74), (186  -69), (201  -65), (216  -62),
(231  -60), (246  -60), (261  -60), (276  -60), (291  -61), (306  -64),
(321  -67), (336  -72), (349  -80), (362  -89), (372 -101), (379 -115),
(382 -130), (314 -134), (309 -119), (298 -108), (284 -102), (269 -100),
(254  -99), (239 -100), (224 -102), (209 -107), (197 -117), (200 -132),
(213 -140), (228 -145), (243 -148), (258 -151), (273 -154), (288 -156),
(303 -159), (318 -163), (333 -167), (347 -173), (361 -179), (373 -189),
(383 -201), (389 -215), (391 -230), (390 -245), (384 -259), (374 -271),
(363 -282), (349 -289), (335 -295), (320 -299), (305 -302), (290 -304),
(275 -305), (259 -305), (243 -305), (228 -304), (213 -302), (198 -300),
(183 -295), (169 -289), (155 -282), (143 -272), (133 -260), (126 -246),
(136 -223), (152 -222), (168 -221), (365 -131), (348 -132), (331 -133),
(251 -177), (183 -157), (342  -98), (247  -75), (274 -174), (360 -223),
(192  -85), (330 -273), (210 -283), (326  -97), (177 -103), (315 -188),
(175 -139), (366 -250), (321 -204), (344 -232), (331 -113), (162 -129),
(272  -77), (292 -192), (144 -244), (196 -272), (212  -89), (166 -236),
(238 -167), (289 -282), (333 -187), (341 -249), (164 -113), (238 -283),
(344 -265), (176 -248), (312 -273), (299  -85), (154 -261), (265 -287),
(359 -111), (160 -150), (212 -169), (351 -199), (160  -98), (228  -77),
(376 -224), (148 -120), (174 -272), (194 -100), (292 -173), (341 -212),
(369 -209), (189 -258), (198 -159), (275 -190), (322  -82))') ) ;

SELECT ST_Area(geom) AS area, ST_isValid(geom), ST_NPoints(geom)
FROM pgr_alphaShape1((SELECT array_agg(geom) FROM s_test), 14.8123623)
ORDER BY area;
SELECT ST_Area(geom) AS area, ST_isValid(geom), ST_NPoints(geom)
FROM pgr_alphaShape1((SELECT array_agg(geom) FROM s_test), 14.8123624)
ORDER BY area;

SELECT ST_Area(pgr_pointsAsPolygon($$
WITH
Points AS (SELECT (st_dumppoints(geom)).geom FROM s_test)
SELECT row_number() over()::INTEGER AS id, ST_X(geom) AS x, ST_Y(geom) AS y FROM Points
$$, 244.056));

SELECT ST_Area(pgr_pointsAsPolygon($$
WITH
Points AS (SELECT (st_dumppoints(geom)).geom FROM s_test)
SELECT row_number() over()::INTEGER AS id, ST_X(geom) AS x, ST_Y(geom) AS y FROM Points
$$));

SELECT ST_Area(geom)
FROM pgr_alphaShape1((SELECT array_agg(geom) FROM s_test));
