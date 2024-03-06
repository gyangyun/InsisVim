import os

# 1. 新建一个输出目录——"output"
if not os.path.exists("output"):
    os.makedirs("output")

# 2. 分别读取输入目录——"python"下的所有以".snippets"为后缀的文件内容
for filename in os.listdir("python"):
    if filename.endswith(".snippets"):
        # 读取文件内容
        with open(os.path.join("python", filename), "r") as f:
            content = f.readlines()

        # 3. 删除文件中的含"endsnippet"字符串的行
        content = [line for line in content if "endsnippet" not in line]

        # 4. 并且不是以"snippet "字符串开头的行前都添加8个空格
        content = [
            line if line.startswith("snippet ") else "        " + line
            for line in content
        ]

        # 将修改后的内容以原文件名保存到"output"目录
        with open(os.path.join("output", filename), "w") as f:
            f.writelines(content)
