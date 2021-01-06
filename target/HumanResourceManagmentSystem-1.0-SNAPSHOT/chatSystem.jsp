<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="user.EmployeeDao" %>
<%@ page import="user.UserBean" %>
<%@ page import="java.util.List" %>
<%@ page import="chat.MessagesDao" %>
<%@ page import="chat.MessagesBean" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <title>Human Resource Management System</title>
    <link rel="icon" href="img/logo.png" sizes="25x25" type="image/png">
    <link rel="stylesheet" href="style/mainStyle.css">
    <link rel="stylesheet" href="style/chatSystem.css">
</head>

<body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<!--<script type="text/javascript" src="jquery-1.4.2.js"></script>!-->
<div class="content">
    <form id="chatSys" action="chatmessages" method="POST" enctype="multipart/form-data">
        <div class="heading">
            <h3>Chat Corner</h3>
        </div>
        <%HttpSession sss = request.getSession(false);
            if (sss == null || sss.isNew()) {
                request.setAttribute("session", "Expired");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }%>
        <div class="members">
            <table id="tableNames" class="employees">
                <tr></tr>
                <%
                    Object myId = session.getAttribute("empId");
                    EmployeeDao empDao = new EmployeeDao();
                    MessagesDao msgDao = new MessagesDao();
                    List<UserBean> empList = empDao.searchChatEmployees();
                    for(UserBean employee:empList){
                        if(session.getAttribute("empId").equals(employee.getEmpId())){}
                        else{
                        int unseenMsgCount = msgDao.getUnseenMsgCount(employee.getEmpId(),myId);
                %>
                <tr class="memberRows">
                    <td hidden><%=employee.getEmpId()%></td>
                    <td class="name"><%=employee.getFName()%> <%=employee.getLName()%>  </td>
                    <%if(unseenMsgCount > 0){%>
                    <td class="count" align="right"> <%=unseenMsgCount%></td>
                    <%}%>
                </tr>
                <%}}%>
            </table>
        </div>
        <%
            String gId =  (String) request.getAttribute("guestId");
            String gName = (String) request.getAttribute("guestName");
            if(gName==null){ gName = "Welcome To The System Chat Corner!!!";}
            List<MessagesBean> msgList = msgDao.getMessages(myId, gId);
        %>
            <input type="text" class="input" name="sId" id="sId" value="<%=myId%>" hidden readonly>
            <input type="text" class="input" name="gId" id="gId" value="<%=gId%>" hidden readonly>
            <input type="text" class="input" name="gName" id="gName" value="<%=gName%>" hidden readonly>
            <input type="text" class="input" name="fId" id="fId" value="0" hidden readonly>

            <%if(gId!=null){%>
        <h3 name="gN" id="gN" class="name"><%=gName%></h3>
        <div class="chat">

            <div id="chatMsg" class="msgs">
                <%
                    for(MessagesBean msg:msgList){
                        if(myId.equals(msg.getReceiverId())){
                %>
                <table style="width: 820px; ">
                    <tr class="receivedRow">
                        <td class="received">
                            <input type="submit" class="delete" name="Send" id="delete" value="X" style="float: right; color: red ;margin-right: 10px"><br>
                            <%=msg.getMsgText()%><br>
                            <%if(msg.getMsgFileName()!=null){%>
                            <p id="<%=msg.getMsgId()%>" onclick="downloadFile(this.id)"><a href="#"><%=msg.getMsgFileName()%></a></p><br><%}%>
                            <!--<input type="submit" class="send" name="" id="" value="" onclick="downloadFile(this.id)">!-->
                            <span style="float:right; color: grey"><%=msg.getMsgDateTime()%></span>
                        </td>
                        <td>

                        </td>
                    </tr>

                </table>

                <%
                }else{
                %>
                <table style="width: 820px; ">
                    <tr class="sentRow">
                        <td>

                        </td>
                        <td class="sent">
                            <input type="submit" class="delete" name="Send" id="delete1" value="X" style="float: right; color: red; margin-left:  10px"><br>
                            <%=msg.getMsgText()%><br>
                            <%if(msg.getMsgFileName()!=null){%>
                            <p id="<%=msg.getMsgId()%>" onclick="downloadFile(this.id)"><a href="#" ><%=msg.getMsgFileName()%></a></p><br><%}%>
                            <span style="float:right; color: grey"><%=msg.getMsgDateTime()%></span>
                        </td>
                    </tr>

                </table>
                <%}}%>
                <input type="text" class="input" name="msgFileId" id="msgFileId" hidden readonly>
            </div>

            <div class="sendMsg">
                <textarea id="msg" name="msg" class="input" cols="50" rows="3" placeholder="Type a Message"></textarea>
                <input type="file" class="fileChoose" id="fbtn" name="fbtn" oninput="getFileName()">
                <input type="submit" class="send" name="Send" id="btnSend" value="Send">
                <input type="text" class="input" name="fileName" id="fileName" hidden readonly>


            </div>
        </div>
        <%}else{%>
        <div class="image">
            <img class="noPostImg" src="img/chat.jfif" />

        </div>

        <%}%>
    </form>
</div>
<%@include file="mainDashboard.jsp" %>
<script type="text/javascript" src="js/chatSystem.js"></script>
</body>
</html>