

const SPATIALITEFUNCTION = Dict{Symbol, Function}(
    # math functions
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#math
    :acos =>    ex -> "acos($(_sqlexprargs(ex)))",
    :asin =>    ex -> "asin($(_sqlexprargs(ex)))",
    :atan =>    ex -> "atan($(_sqlexprargs(ex)))",
    :atan2 =>   ex -> "atan2($(_sqlexprargs(ex)))",
    :ceil =>    ex -> "ceil($(_sqlexprargs(ex)))",
    :cos =>     ex -> "cos($(_sqlexprargs(ex)))",
    :cot =>     ex -> "cot($(_sqlexprargs(ex)))",
    :degrees => ex -> "degrees($(_sqlexprargs(ex)))",
    :exp =>     ex -> "exp($(_sqlexprargs(ex)))",
    :floor =>   ex -> "floor($(_sqlexprargs(ex)))",
    :log =>     ex -> "log($(_sqlexprargs(ex)))",
    :log2 =>    ex -> "log2($(_sqlexprargs(ex)))",
    :log10 =>   ex -> "log10($(_sqlexprargs(ex)))",
    :(^) =>     ex -> "power($(_sqlexprargs(ex)))",
    :radians => ex -> "radians($(_sqlexprargs(ex)))",
    :sign =>    ex -> "sign($(_sqlexprargs(ex)))",
    :sin =>     ex -> "sin($(_sqlexprargs(ex)))",
    :sqrt =>    ex -> "sqrt($(_sqlexprargs(ex)))",
    :std =>     ex -> "stddev_samp($(_sqlexprargs(ex)))",
    :tan =>     ex -> "tan($(_sqlexprargs(ex)))",
    :var =>     ex -> "var_samp($(_sqlexprargs(ex)))",

    # BLOB utility functions
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#blob
    :iszipblob =>       ex -> "IsZipBlob($(_sqlexprargs(ex)))",
    :ispdfblob =>       ex -> "IsPdfBlob($(_sqlexprargs(ex)))",
    :isgifblob =>       ex -> "IsGifBlob($(_sqlexprargs(ex)))",
    :ispngblob =>       ex -> "IsPngBlob($(_sqlexprargs(ex)))",
    :istiffblob =>      ex -> "IsTiffBlob($(_sqlexprargs(ex)))",
    :isjpegblob =>      ex -> "IsJpegBlob($(_sqlexprargs(ex)))",
    :isexifblob =>      ex -> "IsExifBlob($(_sqlexprargs(ex)))",
    :isexifgpsblob =>   ex -> "IsExifGpsBlob($(_sqlexprargs(ex)))",
    :iswebpblob =>      ex -> "IsWebpBlob($(_sqlexprargs(ex)))",
    :isjp2blob =>       ex -> "IsJP2Blob($(_sqlexprargs(ex)))",
    :getmimetype =>     ex -> "GetMimeType($(_sqlexprargs(ex)))",
    :blobfromfile =>    ex -> "BlobFromFile($(_sqlexprargs(ex)))",
    :blobtofile =>      ex -> "BlobToFile($(_sqlexprargs(ex)))",

    # SQL utility functions [non-standard] for geometric objects
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p0
    :geomfromexifgpsblob => ex -> "GeomFromExifGpsBlob($(_sqlexprargs(ex)))",
    :makepoint =>           ex -> "MakePoint($(_sqlexprargs(ex)))",
    :makepointz =>          ex -> "MakePointZ($(_sqlexprargs(ex)))",
    :makepointm =>          ex -> "MakePointM($(_sqlexprargs(ex)))",
    :makepointzm =>         ex -> "MakePointZM($(_sqlexprargs(ex)))",
    :makeline =>            ex -> "MakeLine($(_sqlexprargs(ex)))",
    :makecircle =>          ex -> "MakeCircle($(_sqlexprargs(ex)))",
    :makeellipse =>         ex -> "MakeEllipse($(_sqlexprargs(ex)))",
    :makearc =>             ex -> "MakeArc($(_sqlexprargs(ex)))",
    :makeellipticarc =>     ex -> "MakeEllipticArc($(_sqlexprargs(ex)))",
    :makecircularsector =>  ex -> "MakeCircularSector($(_sqlexprargs(ex)))",
    :makeellipticsector =>  ex -> "MakeEllipticSector($(_sqlexprargs(ex)))",
    :makecircularstripe =>  ex -> "MakeCircularStripe($(_sqlexprargs(ex)))",
    :squaregrid =>          ex -> "ST_SquareGrid($(_sqlexprargs(ex)))",
    :triangulargrid =>      ex -> "ST_TriangularGrid($(_sqlexprargs(ex)))",
    :hexagonalgrid =>       ex -> "ST_HexagonalGrid($(_sqlexprargs(ex)))",
    :buildmbr =>            ex -> "BuildMbr($(_sqlexprargs(ex)))",
    :buildcirclembr =>      ex -> "BuildCircleMbr($(_sqlexprargs(ex)))",
    :extent =>              ex -> "Extent($(_sqlexprargs(ex)))",
    :toGARS =>              ex -> "ToGARS($(_sqlexprargs(ex)))",
    :mbrGARS =>             ex -> "GARSMbr($(_sqlexprargs(ex)))",
    :minx =>                ex -> "ST_MinX($(_sqlexprargs(ex)))",
    :miny =>                ex -> "ST_MinY($(_sqlexprargs(ex)))",
    :maxx =>                ex -> "ST_MaxX($(_sqlexprargs(ex)))",
    :maxy =>                ex -> "ST_MaxY($(_sqlexprargs(ex)))",
    :minz =>                ex -> "ST_MinZ($(_sqlexprargs(ex)))",
    :maxz =>                ex -> "ST_MaxZ($(_sqlexprargs(ex)))",
    :minm =>                ex -> "ST_MinM($(_sqlexprargs(ex)))",
    :maxm =>                ex -> "ST_MaxM($(_sqlexprargs(ex)))",

    # SQL functions for constructing a geometric object given its WKT
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p1
    :geomfromtext =>        ex -> "ST_GeomFromText($(_sqlexprargs(ex)))",
    :pointfromtext =>       ex -> "ST_PointFromText($(_sqlexprargs(ex)))",
    :linefromtext =>        ex -> "ST_LineStringFromText($(_sqlexprargs(ex)))",
    :polyfromtext =>        ex -> "ST_PolygonFromText($(_sqlexprargs(ex)))",
    :mpointfromtext =>      ex -> "ST_MultiPointFromText($(_sqlexprargs(ex)))",
    :mlinefromtext =>       ex ->
        "ST_MultiLineStringFromText($(_sqlexprargs(ex)))",
    :mpolyfromtext =>       ex ->
        "ST_MultiPolygonFromText($(_sqlexprargs(ex)))",
    :geomcolfromtext =>     ex ->
        "ST_GeometryCollectionFromText($(_sqlexprargs(ex)))",
    :buildpolyfromtext =>   ex -> "ST_BdPolyFromText($(_sqlexprargs(ex)))",
    :buildmpolyfromtext =>  ex -> "ST_BdMPolyFromText($(_sqlexprargs(ex)))",

    # SQL functions for constructing a geometric object given its WKB
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p2
    :geomfromwkb =>         ex -> "ST_GeomFromWKB($(_sqlexprargs(ex)))",
    :pointfromwkb =>        ex -> "ST_PointFromWKB($(_sqlexprargs(ex)))",
    :linefromwkb =>         ex -> "ST_LineFromWKB($(_sqlexprargs(ex)))",
    :polyfromwkb =>         ex -> "ST_PolygonFromWKB($(_sqlexprargs(ex)))",
    :mpointfromwkb =>       ex -> "ST_MultiPointFromWKB($(_sqlexprargs(ex)))",
    :mlinefromwkb =>        ex ->
        "ST_MultiLineStringFromWKB($(_sqlexprargs(ex)))",
    :mpolyfromwkb =>        ex ->
        "ST_MultiPolygonFromWKB($(_sqlexprargs(ex)))",
    :geomcolfromwkb =>      ex ->
        "ST_GeometryCollectionFromWKB($(_sqlexprargs(ex)))",
    :buildpolyfromwkb =>    ex -> "ST_BdPolyFromWKB($(_sqlexprargs(ex)))",
    :buildmpolyfromwkb =>   ex -> "ST_BdMPolyFromWKB($(_sqlexprargs(ex)))",

    # SQL functions supporting various geometric formats
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p3
    :astext =>          ex -> "ST_AsText($(_sqlexprargs(ex)))",
    :asWKT =>           ex -> "AsWKT($(_sqlexprargs(ex)))",
    :asbinary =>        ex -> "ST_AsBinary($(_sqlexprargs(ex)))",
    :asSVG =>           ex -> "AsSVG($(_sqlexprargs(ex)))",
    :asKML =>           ex -> "AsKml($(_sqlexprargs(ex)))",
    :geomfromKML =>     ex -> "GeomFromKml($(_sqlexprargs(ex)))",
    :asGML =>           ex -> "AsGml($(_sqlexprargs(ex)))",
    :geomfromGML =>     ex -> "GeomFromGML($(_sqlexprargs(ex)))",
    :asGeoJSON =>       ex -> "AsGeoJSON($(_sqlexprargs(ex)))",
    :geomfromGeoJSON => ex -> "GeomFromGeoJSON($(_sqlexprargs(ex)))",
    :asEWKB =>          ex -> "AsEWKB($(_sqlexprargs(ex)))",
    :geomfromEWKB =>    ex -> "GeomFromEWKB($(_sqlexprargs(ex)))",
    :asEWKT =>          ex -> "AsEWKT($(_sqlexprargs(ex)))",
    :geomfromEWKT =>    ex -> "GeomFromEWKT($(_sqlexprargs(ex)))",
    :asFGF =>           ex -> "AsFGF($(_sqlexpraex)))",
    :geomfromFGF =>     ex -> "GeomFromFGF($(_sqlexprargs(ex)))",

    # SQL functions on type Geometry
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p4
    :dimension =>       ex -> "ST_Dimension($(_sqlexprargs(ex)))",
    :coorddimension =>  ex -> "CoordDimension($(_sqlexprargs(ex)))",
    :ndim =>            ex -> "ST_NDims($(_sqlexprargs(ex)))",
    :is3D =>            ex -> "ST_Is3D($(_sqlexprargs(ex)))",
    :ismeasured =>      ex -> "ST_IsMeasured($(_sqlexprargs(ex)))",
    :geomtype =>        ex -> "ST_GeometryType($(_sqlexprargs(ex)))",
    :srid =>            ex -> "ST_SRID($(_sqlexprargs(ex)))",
    :setsrid =>         ex -> "SetSRID($(_sqlexprargs(ex)))",
    :isempty =>         ex -> "ST_IsEmpty($(_sqlexprargs(ex)))",
    :issimple =>        ex -> "ST_IsSimple($(_sqlexprargs(ex)))",
    :isvalid  =>        ex -> "ST_IsValid($(_sqlexprargs(ex)))",
    :isvalidreason =>   ex -> "ST_IsValidReason($(_sqlexprargs(ex)))",
    :isvaliddetail =>   ex -> "ST_IsValidDetail($(_sqlexprargs(ex)))",
    :boundary =>        ex -> "ST_Boundary($(_sqlexprargs(ex)))",
    :envelope =>        ex -> "ST_Envelope($(_sqlexprargs(ex)))",
    :expand =>          ex -> "ST_Expand($(_sqlexprargs(ex)))",
    :npoints =>         ex -> "ST_NPoints($(_sqlexprargs(ex)))",
    :nrings =>          ex -> "ST_NRings($(_sqlexprargs(ex)))",
    :reverse =>         ex -> "ST_Reverse($(_sqlexprargs(ex)))",
    :forceLHR =>        ex -> "ST_ForceLHR($(_sqlexprargs(ex)))",

    # SQL functions to repair/compress/uncompress Geometries
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#repair
    :sanitizegeom =>    ex -> "SanitizeGeometry($(_sqlexprargs(ex)))",
    :compressgeom =>    ex -> "CompressGeometry($(_sqlexprargs(ex)))",
    :uncompressgeom =>  ex -> "UncompressGeometry($(_sqlexprargs(ex)))",
    # SQL Geometry-type casting functions
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#cast
    :cast2point =>      ex -> "CastToPoint($(_sqlexprargs(ex)))",
    :cast2line =>       ex -> "CastToLinestring($(_sqlexprargs(ex)))",
    :cast2poly =>       ex -> "CastToPolygon($(_sqlexprargs(ex)))",
    :cast2mpoint =>     ex -> "CastToMultiPoint($(_sqlexprargs(ex)))",
    :cast2mline =>      ex -> "CastToMultiLinestring($(_sqlexprargs(ex)))",
    :cast2mpoly =>      ex -> "CastToMultiPolygon($(_sqlexprargs(ex)))",
    :cast2geomcol =>    ex -> "CastToGeometryCollection($(_sqlexprargs(ex)))",
    :cast2multi =>      ex -> "ST_Multi($(_sqlexprargs(ex)))",
    :cast2single =>     ex -> "CastToSingle($(_sqlexprargs(ex)))",
    :cast2xy =>         ex -> "CastToXY($(_sqlexprargs(ex)))",
    :cast2xyz =>        ex -> "CastToXYZ($(_sqlexprargs(ex)))",
    :cast2xym =>        ex -> "CastToXYM($(_sqlexprargs(ex)))",
    :cast2xyzm =>       ex -> "CastToXYZM($(_sqlexprargs(ex)))",

    # SQL functions on various Geometries
    # # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p5
    # Point
    :x =>                       ex -> "ST_X($(_sqlexprargs(ex)))",
    :y =>                       ex -> "ST_Y($(_sqlexprargs(ex)))",
    :z =>                       ex -> "ST_Z($(_sqlexprargs(ex)))",
    :m =>                       ex -> "ST_M($(_sqlexprargs(ex)))",
    # Curve [Linestring or Ring]
    :startpoint =>              ex -> "ST_StartPoint($(_sqlexprargs(ex)))",
    :endpoint =>                ex -> "ST_EndPoint($(_sqlexprargs(ex)))",
    :geomlength =>              ex -> "ST_Length($(_sqlexprargs(ex)))",
    :perimeter =>               ex -> "ST_Perimeter($(_sqlexprargs(ex)))",
    :geodesiclength =>          ex -> "GeodesicLength($(_sqlexprargs(ex)))",
    :greatcirclelength =>       ex -> "GreatCircleLength($(_sqlexprargs(ex)))",
    :isclosed =>                ex -> "ST_IsClosed($(_sqlexprargs(ex)))",
    :isring =>                  ex -> "ST_IsRing($(_sqlexprargs(ex)))",
    :pointonsurface =>          ex -> "ST_PointOnSurface($(_sqlexprargs(ex)))",
    :simplify =>                ex -> "ST_Simplify($(_sqlexprargs(ex)))",
    :simplifypreservetopo =>    ex ->
        "ST_SimplifyPreserveTopology($(_sqlexprargs(ex)))",
    # LineString
    :npoint =>                  ex -> "ST_NumPoints($(_sqlexprargs(ex)))",
    :nthpoint =>                ex -> "ST_PointN($(_sqlexprargs(ex)))",
    :addpoint =>                ex -> "ST_AddPoint($(_sqlexprargs(ex)))",
    :setpoint =>                ex -> "ST_SetPoint($(_sqlexprargs(ex)))",
    :setstartpoint =>           ex -> "ST_SetStartPoint($(_sqlexprargs(ex)))",
    :setendpoint =>             ex -> "ST_SetEndPoint($(_sqlexprargs(ex)))",
    :removepoint =>             ex -> "ST_RemovePoint($(_sqlexprargs(ex)))",
    # Surface [Polygon or Ring]
    :centroid =>                ex -> "ST_Centroid($(_sqlexprargs(ex)))",
    :area  =>                   ex -> "ST_Area($(_sqlexprargs(ex)))",
    # Polygon
    :exteriorring =>            ex -> "ST_ExteriorRing($(_sqlexprargs(ex)))",
    :ninteriorring =>           ex -> "ST_NumInteriorRing($(_sqlexprargs(ex)))",
    :nthinteriorring =>         ex -> "ST_InteriorRingN($(_sqlexprargs(ex)))",
    # GeomCollection
    :ngeom =>                   ex -> "ST_NumGeometries($(_sqlexprargs(ex)))",
    :nthgeom =>                 ex -> "ST_GeometryN($(_sqlexprargs(ex)))",

    # SQL functions that test spatial relationships via MBRs
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p11
    :mbrequal =>        ex -> "MbrEqual($(_sqlexprargs(ex)))",
    :mbrdisjoint =>     ex -> "MbrDisjoint($(_sqlexprargs(ex)))",
    :mbrtouches =>      ex -> "MbrTouches($(_sqlexprargs(ex)))",
    :mbrwithin =>       ex -> "MbrWithin($(_sqlexprargs(ex)))",
    :mbroverlaps =>     ex -> "MbrOverlaps($(_sqlexprargs(ex)))",
    :mbrintersects =>   ex -> "MbrIntersects($(_sqlexprargs(ex)))",
    :mbrcontains =>     ex -> "MbrContains($(_sqlexprargs(ex)))",
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p12
    :equals =>          ex -> "ST_Equals($(_sqlexprargs(ex)))",
    :disjoint =>        ex -> "ST_Disjoint($(_sqlexprargs(ex)))",
    :touches =>         ex -> "ST_Touches($(_sqlexprargs(ex)))",
    :within =>          ex -> "ST_Within($(_sqlexprargs(ex)))",
    :overlaps =>        ex -> "ST_Overlaps($(_sqlexprargs(ex)))",
    :crosses =>         ex -> "ST_Crosses($(_sqlexprargs(ex)))",
    :intersects =>      ex -> "ST_Intersects($(_sqlexprargs(ex)))",
    :contains =>        ex -> "ST_Contains($(_sqlexprargs(ex)))",
    :covers =>          ex -> "ST_Covers($(_sqlexprargs(ex)))",
    :coveredby =>       ex -> "ST_CoveredBy($(_sqlexprargs(ex)))",
    :relate =>          ex -> "ST_Relate($(_sqlexprargs(ex)))",
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p13
    :distance =>        ex -> "ST_Distance($(_sqlexprargs(ex)))",
    :withindist =>      ex -> "PtDistWithin($(_sqlexprargs(ex)))",
    
    # SQL functions that implement spatial operators
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p14
    :intersection =>        ex -> "ST_Intersection($(_sqlexprargs(ex)))",
    :difference =>          ex -> "ST_Difference($(_sqlexprargs(ex)))",
    :geomunion =>           ex -> "ST_Union($(_sqlexprargs(ex)))",
    :symdifference =>       ex -> "ST_SymDifference($(_sqlexprargs(ex)))",
    :buffer =>              ex -> "ST_Buffer($(_sqlexprargs(ex)))",
    :convexhull =>          ex -> "ST_ConvexHull($(_sqlexprargs(ex)))",
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p14b
    :hausdorffdistance =>   ex -> "ST_HausdorffDistance($(_sqlexprargs(ex)))",
    :offsetcurve =>         ex -> "ST_OffsetCurve($(_sqlexprargs(ex)))",
    :singlesidedbuffer =>   ex -> "ST_SingleSidedBuffer($(_sqlexprargs(ex)))",
    :sharedpaths =>         ex -> "ST_SharedPaths($(_sqlexprargs(ex)))",
    :lineinterpolate =>     ex ->
        "ST_Line_Interpolate_Point($(_sqlexprargs(ex)))",
    :lineequidistant =>     ex ->
        "ST_Line_Interpolate_Equidistant_Points($(_sqlexprargs(ex)))",
    :linelocate =>          ex -> "ST_Line_Locate_Point($(_sqlexprargs(ex)))",
    :linesubstring =>       ex -> "ST_Line_Substring($(_sqlexprargs(ex)))",
    :closestpoint =>        ex -> "ST_ClosestPoint($(_sqlexprargs(ex)))",
    :shortestline =>        ex -> "ST_ShortestLine($(_sqlexprargs(ex)))",
    :geomcollect =>         ex -> "ST_Collect($(_sqlexprargs(ex)))",
    :linemerge =>           ex -> "ST_LineMerge($(_sqlexprargs(ex)))",
    :buildarea =>           ex -> "ST_BuildArea($(_sqlexprargs(ex)))",
    :polygonize =>          ex -> "ST_Polygonize($(_sqlexprargs(ex)))",
    :makepolygon =>         ex -> "ST_MakePolygon($(_sqlexprargs(ex)))",
    :unaryunion =>          ex -> "ST_UnaryUnion($(_sqlexprargs(ex)))",
    :dissolvesegments =>    ex -> "ST_DissolveSegments($(_sqlexprargs(ex)))",
    :dissolvepoints =>      ex -> "ST_DissolvePoints($(_sqlexprargs(ex)))",
    :linesfromrings =>      ex -> "ST_LinesFromRings($(_sqlexprargs(ex)))",
    :linescutatnodes =>     ex -> "ST_LinesCutAtNodes($(_sqlexprargs(ex)))",
    :ringscutatnodes =>     ex -> "ST_RingsCutAtNodes($(_sqlexprargs(ex)))",
    :collectionextract =>   ex -> "ST_CollectionExtract($(_sqlexprargs(ex)))",
    :extractmpoint =>       ex -> "ExtractMultiPoint($(_sqlexprargs(ex)))",
    :extractmline =>        ex -> "ExtractMultiLinestring($(_sqlexprargs(ex)))",
    :extractmpoly =>        ex -> "ExtractMultiPolygon($(_sqlexprargs(ex)))",
    :locatealongmeasure =>  ex ->
        "ST_Locate_Along_Measure($(_sqlexprargs(ex)))",
    :locatebetweenmeasures => ex ->
        "ST_Locate_Between_Measures($(_sqlexprargs(ex)))",
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p14c
    :delaunaytriangulation => ex ->
        "ST_DelaunayTriangulation($(_sqlexprargs(ex)))",
    :voronojdiagram =>      ex -> "ST_VoronojDiagram($(_sqlexprargs(ex)))",
    :concavehull =>         ex -> "ST_ConcaveHull($(_sqlexprargs(ex)))",
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p14d
    :makevalid =>           ex -> "ST_MakeValid($(_sqlexprargs(ex)))",
    :makevaliddiscarded =>  ex -> "ST_MakeValidDiscarded($(_sqlexprargs(ex)))",
    :segmentize =>          ex -> "ST_Segmentize($(_sqlexprargs(ex)))",
    :split =>               ex -> "ST_Split($(_sqlexprargs(ex)))",
    :splitleft =>           ex -> "ST_SplitLeft($(_sqlexprargs(ex)))",
    :splitright =>          ex -> "ST_SplitRight($(_sqlexprargs(ex)))",
    :azimuth =>             ex -> "ST_Azimuth($(_sqlexprargs(ex)))",
    :project =>             ex -> "ST_Project($(_sqlexprargs(ex)))",
    :snaptogrid =>          ex -> "ST_SnapToGrid($(_sqlexprargs(ex)))",
    :geohash =>             ex -> "ST_GeoHash($(_sqlexprargs(ex)))",
    :asX3D =>               ex -> "ST_AsX3D($(_sqlexprargs(ex)))",
    :maxdistance =>         ex -> "ST_MaxDistance($(_sqlexprargs(ex)))",
    :distance3D =>          ex -> "ST_3DDistance($(_sqlexprargs(ex)))",
    :maxdistance3D =>       ex -> "ST_3DMaxDistance($(_sqlexprargs(ex)))",
    :node =>                ex -> "ST_Node($(_sqlexprargs(ex)))",
    :selfintersections =>   ex -> "ST_SelfIntersections($(_sqlexprargs(ex)))",

    # SQL functions for coordinate transformations
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p15
    :transform =>           ex -> "ST_Transform($(_sqlexprargs(ex)))",
    :sridfromauthCRS =>     ex -> "SridFromAuthCRS($(_sqlexprargs(ex)))",
    :shiftcoords =>         ex -> "ShiftCoordinates($(_sqlexprargs(ex)))",
    :translate =>           ex -> "ST_Translate($(_sqlexprargs(ex)))",
    :shiftlongitude =>      ex -> "ST_Shift_Longitude($(_sqlexprargs(ex)))",
    :normalizelonlat =>     ex -> "NormalizeLonLat($(_sqlexprargs(ex)))",
    :scalecoords =>         ex -> "ScaleCoordinates($(_sqlexprargs(ex)))",
    :rotatecoords =>        ex -> "RotateCoordinates($(_sqlexprargs(ex)))",
    :reflectcoords =>       ex -> "ReflectCoordinates($(_sqlexprargs(ex)))",
    :swapcoords =>          ex -> "SwapCoordinates($(_sqlexprargs(ex)))",

    # SQL functions supporting Affine Transformations and Ground Control Points
    # http://www.gaia-gis.it/gaia-sins/spatialite-sql-4.3.0.html#p15plus
    :atmcreate =>           ex -> "ATM_Create($(_sqlexprargs(ex)))",
    :atmcreatetranslate =>  ex -> "ATM_CreateTranslate($(_sqlexprargs(ex)))",
    :atmcreatescale =>      ex -> "ATM_CreateScale($(_sqlexprargs(ex)))",
    :atmcreaterotate =>     ex -> "ATM_CreateRotate($(_sqlexprargs(ex)))",
    :atmcreatexroll =>      ex -> "ATM_CreateXRoll($(_sqlexprargs(ex)))",
    :atmcreateyroll =>      ex -> "ATM_CreateYRoll($(_sqlexprargs(ex)))",
    :atmmultiply =>         ex -> "ATM_Multiply($(_sqlexprargs(ex)))",
    :atmtranslate =>        ex -> "ATM_Translate($(_sqlexprargs(ex)))",
    :atmscale =>            ex -> "ATM_Scale($(_sqlexprargs(ex)))",
    :atmrotate =>           ex -> "ATM_Rotate($(_sqlexprargs(ex)))",
    :atmxroll =>            ex -> "ATM_XRoll($(_sqlexprargs(ex)))",
    :atmyroll =>            ex -> "ATM_YRoll($(_sqlexprargs(ex)))",
    :atmdeterminant =>      ex -> "ATM_Determinant($(_sqlexprargs(ex)))",
    :atmisinvertible =>     ex -> "ATM_IsInvertible($(_sqlexprargs(ex)))",
    :atminvert =>           ex -> "ATM_Invert($(_sqlexprargs(ex)))",
    :atmisvalid =>          ex -> "ATM_IsValid($(_sqlexprargs(ex)))",
    :atmastext =>           ex -> "ATM_AsText($(_sqlexprargs(ex)))",
    :atmtransform =>        ex -> "ATM_Transform($(_sqlexprargs(ex)))"
)
