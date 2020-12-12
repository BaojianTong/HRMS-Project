
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="DBconnection.DBconn" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="leave.LeaveBean" %>
<%@ page import="leave.LeaveDao" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import ="java.util.Date" %>

<html>
<head>
    <title>Human Resource Management System</title>
    <link rel="icon" href="img/logo.png" sizes="25x25" type="image/png">
    <link rel="stylesheet" href="style/mainStyle.css">
    <link rel="stylesheet" href="style/applyForLeave.css">
</head>
<body>
<div class="content">

    <div class="heading"><h3>Apply For Leave</h3>
    </div>
    <form action="applyLeave" method="POST">

    <%
        String result= (String) request.getAttribute("result");

    if(result != null){

        if(result=="Successful"){%>
                <h4 class="response" style="color: #4bbe19;">
                    Your Leave is Successfully Send! , Response Will Be Notify Soon.
                </h4><%

        }request.setAttribute("result",null);
    %>
        <%
         if(result == "Unsuccessful"){%>
                <h4 class="response" style="color: #DC143C;">
                    Unable To Send Your Leave! , Try Again.
                </h4>
    <%} request.setAttribute("result",null);}
        request.setAttribute("result",null);
    %>
    <%
        LeaveDao empDao = new LeaveDao();
        List<LeaveBean> leaveList = empDao.searchEmployeeToApproveLeave();

    %>

    <div class="leaves">
        <table>
            <%
                ResultSet rs = null;
                try {
                    Connection con = DBconn.getConnection();
                    Statement statement = con.createStatement();
                    rs = statement.executeQuery("SELECT remainingPayedLeaves ,remainingNoPayLeaves ,remainingMedicalLeaves  FROM employeeleavedetails where empId="+session.getAttribute("empId"));

                    while (rs.next()) {%>
            <tr>
                <td>
                    <label class="label">Remaining Payed Leaves</label>
                </td>
                <td>
                    <label class="label">Remaining NoPayed Leaves</label>
                </td>
                <td>
                    <label class="label">Remaining Medical Leaves</label>
                </td>
            </tr>
            <tr>
                <th>
                    <input class="input" type="text" name="leavesPayed" id="leavesPayed" value="<%=rs.getInt("remainingPayedLeaves")%>" readonly>
                </th>

                <th>
                    <input class="input" type="text" name="leavesNoPay" id="leavesNoPay" value="<%=rs.getInt("remainingNoPayLeaves")%>" readonly>
                </th>

                <th>
                    <input class="input" type="text" name="leavesMedical" id="leavesMedical" value="<%=rs.getInt("remainingMedicalLeaves")%>" readonly>
                </th>

            </tr>

            <%}} catch (SQLException e) {
                e.printStackTrace();
            }%>
        </table>

    </div>

    <div class="main">
        <table>

            <th>
            <tr hidden>
                <td>
                    <label class="label" hidden>Leave ID</label>
                </td>
                <%
                    ResultSet rs2= null;
                    try {

                        Connection con = DBconn.getConnection();
                        Statement statement = con.createStatement();
                        rs2 = statement.executeQuery("SELECT leaveId FROM leavedetails ORDER BY leaveId DESC LIMIT 1");
                        if (rs2.next()) {%>

                <th>
                    <input hidden class="input" type="text" name="leaveId" id="idelse" value="<%=rs2.getInt("leaveId")+1%>" readonly>
                </th>

            </tr>
            <%}else {%>
            <th>
                <input class="input" type="text" name="leaveId" id="id" value="100" readonly>
            </th>

            </tr>
                    <%}


                    } catch (SQLException e) {
                e.printStackTrace();
            }

                Date date = new Date();
                SimpleDateFormat formatter = new SimpleDateFormat("yyy-MM-dd");
                String appliedDate= formatter.format(date);
            %>

            <tr>
                <td>
                    <label class="label">Applied Date</label>
                </td>
                <th>
                    <input class="input" type="text" value="<%=appliedDate%>" name="appliedDate" id="applied" readonly>
                </th>
            </tr>
            <tr>
                <td>
                    <label class="label">From Date</label>
                </td>
                <th>
                    <input class="input" type="date" name="fromDate" id="from">
                </th>
            </tr>
            <tr>
                <td>
                    <label class="label">To Date</label>
                </td>
                <th>
                    <input class="input" type="date" name="toDate" id="to">
                </th>
            </tr>


        </table>
        <table id="reasonA">
            <tr>
                <td>
                    <label class="label">Reason for Leave Appling...</label>
                </td>
            </tr>
            <tr>
                <th>
                    <textarea class="textarea" rows="5" cols="100" name="reason" id="reason"></textarea>
                </th>
            </tr>
        </table>
        <br>
        <table>
            <tr>
                <td>
                    <label class="label">Leave Type</label>
                </td>
                <th>
                    <select class="type" name="leavetype"  id="sat" placeholder="Select Leave Type">
                        <option  class="type">Select Leave Type</option>
                        <option  class="type" value="Payed">Payed</option>
                        <option  class="type" value="NoPay">NoPay</option>
                        <option  class="type" value="Medical">Medical</option>
                    </select>
                </th>

            </tr>

            <tr>
                <td>
                    <label class="label">Request From</label>
                </td>
                <th>
                    <input class="input" type="text" name="authorizedPersonId" id="empId"  placeholder="Select Sender for this Request From the given List" READONLY>
                </th>
            </tr>
        </table>
    </div>
    <div class="btn">
        <table>
            <tr>
                <td></td>
                <th>

                </th>
                <th>
                    <input class="apply" type="submit" value="Apply"/>
                </th>
            </tr>
        </table>

    </div>
        <input class="input" type="number" name="empId" value="<%=session.getAttribute("empId")%>" hidden>
</form>

    <div class="result">
        <br>
        <table id="tableResult">

            <tr>
                <th>
                    Employee Id
                </th>
                <th>
                    Name
                </th>
                <th>
                    NIC
                </th>
            </tr>
            <%
                for(LeaveBean leave:leaveList){
                    if(session.getAttribute("empId").equals(leave.getEmpId())){}
                    else{
            %>
            <tr>
                <td class="empIdd"><%=leave.getEmpId()%></td>
                <td class="empName"><%=leave.getFName()%></td>
                <td class="empNIC"><%=leave.getNIC()%><%}}%></td>

            </tr>
        </table>

    </div>
</div>
<%@include file="mainDashboard.jsp" %>
<script type="text/javascript" src="js/loadDataToTable.js"></script>
</body>
</html>
