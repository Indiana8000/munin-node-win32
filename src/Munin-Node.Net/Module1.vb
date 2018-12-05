Imports System.Net.Sockets
Imports System.Text

'Imports SpeedFanConnector


Module Module1
    Sub Main()


        Dim connector As New SpeedFanConnector.SFConnector


        Debug.Print(SpeedFanConnector.SFConnector.SpeedFanPath)

        Debug.Print(SpeedFanConnector.SFConnector.SpeedFanAlreadyRunning)
        Dim i As Integer
        For i = 0 To connector.TemperatureCount - 1
            Debug.Print(connector.TemperatureValues(i))


        Next

        connector.Dispose()


        Dim objProcess As New Process()
        Dim strOutput As String
        Dim strError As String

        ' Start the Command and redirect the output

        objProcess.StartInfo.UseShellExecute = False
        objProcess.StartInfo.RedirectStandardOutput = True
        objProcess.StartInfo.CreateNoWindow = True
        objProcess.StartInfo.RedirectStandardError = True
        objProcess.StartInfo.FileName() = "cmd.exe"
        objProcess.StartInfo.Arguments() = "/C dir"
        objProcess.Start()

        strOutput = objProcess.StandardOutput.ReadToEnd()
        strError = objProcess.StandardError.ReadToEnd()
        objProcess.WaitForExit()








        Dim serverSocket As New TcpListener(8888)
        Dim clientSocket As TcpClient
        Dim counter As Integer

        serverSocket.Start()
        msg("Server Started")
        counter = 0
        While (True)
            counter += 1
            clientSocket = serverSocket.AcceptTcpClient()
            msg("Client No:" + Convert.ToString(counter) + " started!")
            Dim client As New handleClinet
            client.startClient(clientSocket, Convert.ToString(counter))
        End While

        clientSocket.Close()
        serverSocket.Stop()
        msg("exit")
        Console.ReadLine()
    End Sub

    Sub msg(ByVal mesg As String)
        mesg.Trim()
        Console.WriteLine(" >> " + mesg)
    End Sub

    Public Class handleClinet
        Dim clientSocket As TcpClient
        Dim clNo As String
        Public Sub startClient(ByVal inClientSocket As TcpClient, ByVal clineNo As String)
            Me.clientSocket = inClientSocket
            Me.clNo = clineNo
            Dim ctThread As Threading.Thread = New Threading.Thread(AddressOf doChat)
            ctThread.Start()
        End Sub
        Private Sub doChat()
            Dim requestCount As Integer
            Dim bytesFrom(10024) As Byte
            Dim dataFromClient As String
            Dim sendBytes As [Byte]()
            Dim serverResponse As String
            Dim rCount As String
            requestCount = 0

            While (True)
                Try
                    requestCount = requestCount + 1
                    Dim networkStream As NetworkStream = clientSocket.GetStream()
                    networkStream.Read(bytesFrom, 0, CInt(clientSocket.ReceiveBufferSize))
                    dataFromClient = System.Text.Encoding.ASCII.GetString(bytesFrom)
                    dataFromClient = dataFromClient.Substring(0, dataFromClient.IndexOf("$"))
                    msg("From client-" + clNo + dataFromClient)
                    rCount = Convert.ToString(requestCount)
                    serverResponse = "Server to clinet(" + clNo + ") " + rCount
                    sendBytes = Encoding.ASCII.GetBytes(serverResponse)
                    networkStream.Write(sendBytes, 0, sendBytes.Length)
                    networkStream.Flush()
                    msg(serverResponse)
                Catch ex As Exception
                    MsgBox(ex.ToString)
                End Try

            End While

        End Sub
    End Class
End Module
