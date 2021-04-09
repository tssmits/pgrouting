create extension if not exists postgis;
create extension if not exists pgrouting;

drop schema if exists temp_nodenetwork;
create schema temp_nodenetwork;

set client_min_messages to 'debug';

DROP TABLE if exists ferry_lines;
DROP TABLE if exists ferry_lines_noded;

CREATE TABLE ferry_lines (
    id serial NOT NULL PRIMARY KEY
);
SELECT addgeometrycolumn('ferry_lines', 'the_geom', 3857, 'LINESTRING', 2);

INSERT INTO ferry_lines (the_geom)
VALUES ('SRID=3857;LINESTRING(485576.320153051 6783007.31476443,485861.264653635 6782543.98101971,485901.874003876 6782039.97326781,484602.452719795 6781829.7808423,483164.472065524 6781213.50519583,482204.241269891 6781046.28433231,480856.006389097 6781060.93180407,477875.983620561 6781662.56530431,476872.750105634 6782035.19241651,473724.501322611 6783989.11773123,472085.889550083 6784872.91610692,471259.409122638 6785556.06983642,470796.008346363 6786229.67841094,470385.161501693 6787032.26986007,469573.019024661 6787868.30442476,465880.150764881 6790108.85474372,464064.774772923 6791522.93810142,459521.548054922 6795121.45126435,457574.79279993 6795533.49638649,454666.960721173 6796832.09432145,451853.917188827 6797960.47404732,448367.869410992 6799401.40358309,354407.306241091 6871541.47020535,197073.770345029 6974802.38677226,39460.9449785156 7076085.25695878,25435.6242222857 7085160.96570943,18408.6481576548 7084357.63135698,3768.79928444983 7092235.27533111,-1331.68167251269 7092929.69282493,-14090.8211446126 7099570.23983919,-19440.6354970539 7101513.98373642,-20871.3915163726 7100572.45460818,-21488.3686621452 7099761.75649115,-22470.2510987382 7100436.27810749)');
INSERT INTO ferry_lines (the_geom)
VALUES ('SRID=3857;LINESTRING(-31110.0907376765 7121215.35406531,-31134.3917825167 7121003.31060449,-31012.5303359453 7120806.57413867,-29049.8897896164 7119128.59380915,-27518.567742315 7117250.22007497,-26307.7233770584 7114848.56603554,-23488.6018005151 7107427.18076244,-22101.2826465039 7104199.47068546,-20106.0366213216 7101652.0562994,-14127.0333749676 7099447.33224836,-1401.77955586522 7092673.17060156,3672.11830669587 7092047.48474651,18400.8557932993 7084173.47432982,25321.6107998153 7084959.62799206,39121.6209066795 7075684.8997699,194494.019069538 6972719.48559609,352374.701394799 6869567.7135066,448185.049411262 6799271.88189803,451831.208012705 6797798.13110302,454512.081913633 6796272.85208776,457776.603904789 6794798.47256781,459165.848885991 6793932.90476187,459483.844143391 6793445.74849437,459645.903058088 6793065.58678293,459727.689487973 6792570.17304951,459640.804625409 6791646.23080912,459601.764879988 6790651.70626694,459685.644116301 6790226.65399116,459924.546875492 6790175.83558661)');
INSERT INTO ferry_lines (the_geom)
VALUES ('SRID=3857;LINESTRING(-127877.318833101 7284417.49948151,-127957.37981088 7284490.59877857,-129004.629052467 7285574.0626999,-129152.606051578 7286081.73459481,-128670.536996698 7287015.71090045,-128611.125784461 7288111.94419366,-128912.000104177 7289529.90865234,-128949.269869695 7290660.49589593,-125968.234093793 7295637.27631276,-121859.754515137 7296544.9686281,-55567.5171985146 7276485.47973364,356439.922219333 6873515.23649577,448550.678278773 6799530.90926074,451876.615233 6798122.83832413,454000.112443525 6796704.13192362,457804.656416469 6794852.15689985,459183.203594605 6793955.12776495,459515.848496994 6793457.1122494,459675.447250944 6793070.62706526,459754.283714324 6792568.76402509,459610.904210182 6790163.86242683,459505.172957827 6789878.89561193)');
INSERT INTO ferry_lines (the_geom)
VALUES ('SRID=3857;LINESTRING(355071.85020528 6681830.70668071,355140.634518641 6681895.21575677,355410.027686361 6682009.81863436,356650.037758205 6682768.25899137,356795.087054709 6682951.47287231,356780.971743276 6683269.96826294,354489.05927513 6686292.37158964,349803.599643743 6692901.02484821,345627.571398073 6692553.03281489,334900.602626251 6696207.36819811,297586.476291582 6746451.34743848,296021.346514927 6773161.66948506,299376.204272862 7002100.82820938,-55519.9726439967 7276559.42644447,-121764.208996189 7296736.06605828,-126126.519277752 7295710.13414492,-128967.181175764 7290673.6311447,-128933.774196577 7289523.92846645,-128640.235831304 7288113.59757959,-128706.370740784 7287017.94073651,-129170.517357647 7286083.54131518,-129008.536366593 7285570.94919333,-127965.739904638 7284485.52561918,-127877.318833101 7284417.49948151)');

SELECT pgr_nodeNetwork('ferry_lines', 0.0001, 'id', 'the_geom');
SELECT pgr_createtopology('ferry_lines_noded', 0.0001, 'the_geom', 'id');


DROP TABLE IF EXISTS temp_nodenetwork.intergeom;
CREATE TABLE temp_nodenetwork.intergeom AS (
SELECT l1.id AS l1id,
l2.id AS l2id,
l1.the_geom AS line,
_pgr_startpoint(l2.the_geom) AS source,
_pgr_endpoint(l2.the_geom) AS target,
st_closestPoint(l1.the_geom, l2.the_geom) AS geom
FROM (SELECT * FROM public.ferry_lines) AS l1
JOIN (SELECT * FROM public.ferry_lines) AS l2
ON (st_dwithin(l1.the_geom, l2.the_geom, 0.0001))WHERE l1.id <> l2.id
-- AND st_equals(_pgr_startpoint(l1.the_geom),_pgr_startpoint(l2.the_geom))=false AND
-- st_equals(_pgr_startpoint(l1.the_geom),_pgr_endpoint(l2.the_geom))=false AND
-- st_equals(_pgr_endpoint(l1.the_geom),_pgr_startpoint(l2.the_geom))=false AND
-- st_equals(_pgr_endpoint(l1.the_geom),_pgr_endpoint(l2.the_geom))=false
)
