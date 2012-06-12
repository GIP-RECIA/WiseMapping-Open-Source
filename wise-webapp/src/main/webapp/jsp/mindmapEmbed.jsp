<!DOCTYPE HTML>

<%--@elvariable id="mindmap" type="com.wisemapping.model.MindMap"--%>
<%--@elvariable id="editorTryMode" type="java.lang.Boolean"--%>
<%--@elvariable id="editorTryMode" type="java.lang.String"--%>
<%--@elvariable id="mapXml" type="com.wisemapping.model.User"--%>

<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>


<%@ include file="/jsp/init.jsp" %>

<html>
<head>
    <base href="${pageContext.request.contextPath}/"/>
    <title><spring:message code="SITE.TITLE"/> - ${mindmap.title} </title>
    <meta http-equiv="Content-type" content="text/html; charset=UTF-8"/>

    <!--[if lt IE 9]>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <![endif]-->

    <link rel="stylesheet/less" type="text/css" href="css/embedded.less"/>
    <script type='text/javascript' src='js/mootools-core.js'></script>
    <script type='text/javascript' src='js/mootools-more.js'></script>
    <script type='text/javascript' src='js/core.js'></script>
    <script type='text/javascript' src='js/less.js'></script>


    <script type="text/javascript">
        var mapId = '${mindmap.id}';
        var mapXml = '${mindmap.xmlAsJsLiteral}';
        $(document).addEvent('loadcomplete', function(resource) {

            // Configure designer options ...
            var options = loadDesignerOptions();
            options.size.height = options.size.height + 50;

            options.persistenceManager = new mindplot.RESTPersistenceManager("service/maps/");
            var userOptions = ${mindmap.properties};
            options.zoom = ${zoom};

            // Set map id ...
            options.mapId = mapId;

            // Print is read only ...
            options.readOnly = true;

            // Build designer ...
            var designer = buildDesigner(options);

            // Load map from XML ...
            var parser = new DOMParser();
            var domDocument = parser.parseFromString(mapXml, "text/xml");

            var persistence = mindplot.PersistenceManager.getInstance();
            var mindmap = persistence.loadFromDom(mapId, domDocument);
            designer.loadMap(mindmap);

            $('zoomIn').addEvent('click', function() {
                designer.zoomIn();
            });

            $('zoomOut').addEvent('click', function() {
                designer.zoomOut();
            });
        });
    </script>
</head>
<body>
<div id="mapContainer">
    <div id="mindplot"></div>

    <div id="embFooter">
        <a href="${pageContext.request.contextPath}/c/home" target="new">
            <div id="footerLogo"></div>
        </a>

        <div id="zoomIn" class="button"></div>
        <div id="zoomOut" class="button"></div>

        <div id="mapDetails">
            <span class="title"><spring:message code="CREATOR"/>:</span><span>${mindmap.creator.username}</span>
            <span class="title"><spring:message code="DESCRIPTION"/>:</span><span>${mindmap.title}</span>
        </div>
    </div>
</div>

<script type="text/javascript" src="../js/editor.js"></script>
</body>
</html>
