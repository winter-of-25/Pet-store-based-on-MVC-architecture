package csu.web.mypetstore.web.servlet; // 注意这里根据你的截图修改了包名

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DeepSeekServlet", urlPatterns = {"/chatApi"})
public class DeepSeekServlet extends HttpServlet {

    // 【请务必替换】你的 DeepSeek API Key
    private static final String API_KEY = "sk-b58e239eca4c4bbab17ceb5485db5d53";
    private static final String API_URL = "https://api.deepseek.com/chat/completions";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = req.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        String requestBody = sb.toString();
        String userMessage = extractMessage(requestBody);

        if (userMessage == null || userMessage.trim().isEmpty()) {
            resp.getWriter().write("{\"reply\": \"请输入问题\"}");
            return;
        }

        try {
            String aiReply = callDeepSeekAPI(userMessage);
            // 简单处理 JSON 转义
            String safeReply = aiReply.replace("\"", "\\\"").replace("\n", "\\n");
            resp.getWriter().write("{\"reply\": \"" + safeReply + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"reply\": \"AI 助手暂时掉线了。\"}");
        }
    }

    private String callDeepSeekAPI(String userMessage) throws IOException {
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Authorization", "Bearer " + API_KEY);
        conn.setDoOutput(true);

        String systemPrompt = "你是一个专业的宠物店助手。请简短热情地回答用户关于宠物的问题，我商店里面有狗，猫，蜥蜴等等，欢迎购物";

        String jsonInputString = String.format(
                "{" +
                        "  \"model\": \"deepseek-chat\"," +
                        "  \"messages\": [" +
                        "    {\"role\": \"system\", \"content\": \"%s\"}," +
                        "    {\"role\": \"user\", \"content\": \"%s\"}" +
                        "  ]," +
                        "  \"stream\": false" +
                        "}",
                escapeJson(systemPrompt),
                escapeJson(userMessage)
        );

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }

        return extractContentFromResponse(response.toString());
    }

    private String extractMessage(String json) {
        int start = json.indexOf("\"message\":");
        if (start == -1) return "";
        start = json.indexOf("\"", start + 10) + 1;
        int end = json.lastIndexOf("\"");
        // 防止越界
        if (start > end || start == -1 || end == -1) return "";
        return json.substring(start, end);
    }

    private String extractContentFromResponse(String json) {
        String marker = "\"content\":\"";
        int start = json.indexOf(marker);
        if (start == -1) return "无法解析 AI 响应";
        start += marker.length();

        int end = json.indexOf("\"},\"logprobs\"", start);
        if (end == -1) end = json.lastIndexOf("\"}");

        if (start > end) return "解析错误";
        return "DeepSeek 建议：" + json.substring(start, end).replace("\\n", "\n").replace("\\\"", "\"");
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}