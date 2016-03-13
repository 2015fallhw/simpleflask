<?xml version="1.0" encoding="utf-8"?>
<!-- Created by Leo: http://leoeditor.com/leo_toc.html -->
<?xml-stylesheet ekr_test ?>
<leo_file xmlns:leo="http://leoeditor.com/namespaces/leo-python-editor/1.1" >
<leo_header file_format="2" tnodes="0" max_tnode_index="0" clone_windows="0"/>
<globals body_outline_ratio="0.5" body_secondary_ratio="0.5">
	<global_window_position top="50" left="50" height="500" width="700"/>
	<global_log_window_position top="0" left="0" height="0" width="0"/>
</globals>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="amd.20160308180508.2"><vh>簡單的 Flask 網際程式</vh></v>
<v t="amd.20160308180732.1" a="E"><vh>近端與遠端共用程式碼</vh>
<v t="amd.20160308182756.1"><vh>程式功能</vh></v>
</v>
<v t="amd.20160308180556.1" a="E"><vh>@path static</vh>
<v t="amd.20160308181336.1"><vh>@edit axuploader.js </vh></v>
</v>
<v t="amd.20160308181050.1"><vh>@edit setup.py</vh></v>
<v t="amd.20160308181031.1" a="E"><vh>@clean wsgi.py</vh>
<v t="amd.20160308181114.1"><vh>wsgi declarations</vh></v>
</v>
<v t="amd.20160308213741.1" a="E"><vh>@clean init.py</vh>
<v t="amd.20160308213813.1" a="E"><vh>class Init</vh>
<v t="amd.20160308213813.2"><vh>__init__</vh></v>
</v>
</v>
<v t="amd.20160308181042.1" a="E"><vh>@clean myflaskapp.py</vh>
<v t="amd.20160308181134.1"><vh>myflaskapp declarations</vh></v>
<v t="amd.20160308181134.2"><vh>index</vh></v>
<v t="amd.20160308181134.3"><vh>user</vh></v>
<v t="amd.20160308181134.4"><vh>red</vh></v>
<v t="amd.20160308181134.5"><vh>guessform</vh></v>
<v t="amd.20160308181134.6"><vh>docheck</vh></v>
<v t="amd.20160308181134.7"><vh>option</vh></v>
<v t="amd.20160308181134.8"><vh>optionaction</vh></v>
<v t="amd.20160308210121.1"><vh>fileaxupload</vh></v>
<v t="amd.20160308205930.1"><vh>fileuploadform</vh></v>
<v t="amd.20160308215931.1"><vh>download</vh></v>
</v>
<v t="amd.20160308180605.1" a="E"><vh>@path templates</vh>
<v t="amd.20160313095138.1"><vh>@edit docheck.html</vh></v>
<v t="amd.20160313095147.1"><vh>@edit guessform.html</vh></v>
<v t="amd.20160313095201.1"><vh>@edit toobig.html</vh></v>
<v t="amd.20160313095208.1"><vh>@edit toosmall.html</vh></v>
<v t="amd.20160313095048.1"><vh>@edit index.html</vh></v>
<v t="amd.20160313095116.1"><vh>@edit option.html</vh></v>
<v t="amd.20160313095126.1"><vh>@edit optionaction.html</vh></v>
</v>
</vnodes>
<tnodes>
<t tx="amd.20160308180508.2">Flask 是一個 Python 的網際框架

Flask 內定的靜態資料目錄, 名稱為 static

Flask 內定的 templates 目錄, 名稱為 templates</t>
<t tx="amd.20160308180556.1"></t>
<t tx="amd.20160308180605.1">這個 Flask 程式, 在近端用

python wsgi.py 

就可以執行, 若在 Linux 下要用 Python3 啟動:

python3 wsgi.py

若在 OpenShift 雲端平台, 則有兩個條件

1. 必須用 master 分支推送
2. 必須在 .ssh 目錄下有對應的 OpenSSL private key: id_rsa 與遠端的 setting public key 對應</t>
<t tx="amd.20160308180732.1">windows 近端執行:

    python wsgi.py

Linux 近端執行:

    python3 wsgi.py
    
然後以瀏覽器開啟 http://localhost:5000

在 OpenShift 端執行:

1. 使用 master 分支推送到 OpenShift 的 Python3 應用程式

2. OpenShift Python3 應用程式中的 setting 放入 public key, 對應的 private key 放在 .ssh 目錄下的 id_rsa 檔案中

正確啟動用, 連結到 OpenShift Python3 應用程式

http://simpleflask-2014openshift.rhcloud.com/ (採用 2014openshift At Gmail 管理)</t>
<t tx="amd.20160308181031.1">@language python
@tabwidth -4
@others
</t>
<t tx="amd.20160308181042.1">@language python
@tabwidth -4
@others
if __name__ == "__main__":
    app.run()

</t>
<t tx="amd.20160308181114.1">#!/usr/bin/python
# 導入 os 模組, 主要用來判斷是否在 OpenShift 上執行
import os
# 導入同目錄下的 myflaskapp.py
import myflaskapp
    
# 以下開始判斷在 OpenShift 或近端執行
if 'OPENSHIFT_REPO_DIR' in os.environ.keys():
    # 表示程式在雲端執行
    application = myflaskapp.app
else:
    # 表示在近端執行, 以 python3 wsgi.py 執行,  若採 uwsgi 則與 Openshift 運作模式相同
    myflaskapp.app.run(debug=True)
    

</t>
<t tx="amd.20160308181134.1"># coding: utf-8
from flask import Flask, send_from_directory, request, redirect, render_template, session, make_response
import random
import os
# init.py 為自行建立的起始物件
import init

# 確定程式檔案所在目錄, 在 Windows 有最後的反斜線
_curdir = os.path.join(os.getcwd(), os.path.dirname(__file__))
# 設定在雲端與近端的資料儲存目錄
if 'OPENSHIFT_REPO_DIR' in os.environ.keys():
    # 表示程式在雲端執行
    data_dir = os.environ['OPENSHIFT_DATA_DIR']
    static_dir = os.environ['OPENSHIFT_REPO_DIR']+"/static"
    download_dir = os.environ['OPENSHIFT_DATA_DIR']+"/downloads"
else:
    # 表示程式在近端執行
    data_dir = _curdir + "/local_data/"
    static_dir = _curdir + "/static"
    download_dir = _curdir + "/local_data/downloads/"

# 利用 init.py 啟動, 建立所需的相關檔案
initobj = init.Init()

# 必須先將 download_dir 設為 static_folder, 然後才可以用於 download 方法中的 app.static_folder 的呼叫
app = Flask(__name__)
#app.config['download_dir'] = download_dir

# 使用 session 必須要設定 secret_key
# In order to use sessions you have to set a secret key
# set the secret key.  keep this really secret:
app.secret_key = 'A0Zr9@8j/3yX R~XHH!jmN]LWX/,?R@T'







</t>
<t tx="amd.20160308181134.2">@app.route("/")
def index():
    #這是猜數字遊戲的起始表單, 主要在產生答案, 並且將 count 歸零
    # 將標準答案存入 answer session 對應區
    theanswer = random.randint(1, 100)
    thecount = 0
    # 將答案與計算次數變數存進 session 對應變數
    session['answer'] = theanswer
    session['count'] = thecount

    return render_template("index.html", answer=theanswer, count=thecount)
</t>
<t tx="amd.20160308181134.3">@app.route('/user/&lt;name&gt;')
def user(name):
    return render_template("user.html", name=name)
</t>
<t tx="amd.20160308181134.4">@app.route('/red')
def red():
    # 重新導向 google
    return redirect("http://www.google.com")
</t>
<t tx="amd.20160308181134.5">@app.route('/guessform')
def guessform():
    session["count"] += 1
    guess = session.get("guess")
    theanswer = session.get("answer")
    count = session.get("count")
    return render_template("guessform.html", guess=guess, answer=theanswer, count=count)
</t>
<t tx="amd.20160308181134.6">@app.route('/docheck', methods=['POST'])
def docheck():
    # session[] 存資料
    # session.get() 取 session 資料
    # 利用 request.form[] 取得表單欄位資料, 然後送到 template
    guess = request.form["guess"]
    session["guess"] = guess
    # 假如使用者直接執行 doCheck, 則設法轉回根方法
    if guess is None:
        redirect("/")
    # 從 session 取出 answer 對應資料, 且處理直接執行 docheck 時無法取 session 值情況
    try:
        theanswer = int(session.get('answer'))
    except:
        redirect("/")
    # 經由表單所取得的 guess 資料型別為 string
    try:
        theguess = int(guess)
    except:
        return redirect("/guessform")
    # 每執行 doCheck 一次,次數增量一次
    session["count"] += 1
    count = session.get("count")
    # 答案與所猜數字進行比對
    if theanswer &lt; theguess:
        return render_template("toobig.html", guess=guess, answer=theanswer, count=count)
    elif theanswer &gt; theguess:
        return render_template("toosmall.html", guess=guess, answer=theanswer, count=count)
    else:
        # 已經猜對, 從 session 取出累計猜測次數
        thecount = session.get('count')
        return "猜了 "+str(thecount)+" 次, 終於猜對了, 正確答案為 "+str(theanswer)+": &lt;a href='/'&gt;再猜&lt;/a&gt;"
    return render_template("docheck.html", guess=guess)
 
</t>
<t tx="amd.20160308181134.7">@app.route('/option', methods=["GET", "POST"])
def option():
    # 各組選出組長的方式, 若採遞增, 則各組內學號最小者為組長
    option_list1 = ["遞增", "遞減"]
    # 各組組長間的排序定組序, 若採遞增, 則學號最小的組長為第1組
    option_list2 = ["遞增", "遞減"]
    # 電腦教室共有 9 排電腦
    column = 9
    # 根據班級的總人數, 以 9 去除, 算出需要排幾列才能夠容納的下, 而且若列數超過 7
    # 表示這些學員必須與其他同組學員共用電腦

    return render_template('option.html', option_list1=option_list1, option_list2=option_list2, column=column)
</t>
<t tx="amd.20160308181134.8">@app.route('/optionaction', methods=['POST'])
def optionaction():
    # 最後傳回的字串為 out_string
    out_string = ""
    # 程式內需要暫時使用的 tmp_string
    tmp_string = ""
    # 傳回字串中, 用來說明排序原則的 desc_string
    desc_string = ""
    result = []
    group_sorted = []
    # 上面為相關變數的初始值設定, 以下開始取出 data 進行處理
    content = request.form["data"]
    #result = content.splitlines()
    for line in content.splitlines():
        result.append(list(line.split(",")))
    # i 為行序
    for i in range(len(result)):
        # j 為組員序
        for j in range(len(result[i])):
            tmp_string += result[i][j] + ", "
        out_string += "第" + str(i+1) + "排資料:"+ tmp_string + "&lt;br /&gt;"
        tmp_string = ""
    for i in range(len(result)):
        # 開始進入組內排序, 根據 request.form["option1"]  的值決定遞增或遞減
        if request.form["option1"]  == "遞增":
            group_list = sorted(list(filter(None, result[i])))
        else:
            group_list = sorted(list(filter(None, result[i])), reverse=True)
        group_sorted.append(group_list)
    if request.form["option1"]  == "遞增":
        desc_string += "組內學號最小者為組長."
    else:
         desc_string += "組內學號最大者為組長."
    # 開始進入組間組長學號排序, 根據 request.form["option2"] 的值決定遞增或遞減
    if request.form["option2"]  == "遞增":
        desc_string += "各組長中學號最小者為第1組."
        final_result = sorted(group_sorted)
    else:
        desc_string += "各組長中學號最大者為第1組."
        final_result = sorted(group_sorted, reverse=True)
    out_string += "&lt;br /&gt;" + desc_string + "&lt;br /&gt;"
    # i 為行序
    for i in range(len(final_result)):
        # j 為組員序
        for j in range(len(final_result[i])):
            tmp_string += final_result[i][j] + ","
        out_string += "第" + str(i+1) + "組:"+ tmp_string + "&lt;br /&gt;"
        tmp_string = ""
    return out_string
    # 等運算或資料處理結束後, 再將相關值送到對應的 template 進行資料的展示
    #return render_template('optionaction.html', option_list1=option_list1, option_list2=option_list2)
    

</t>
<t tx="amd.20160308182756.1">根目錄為猜數字遊戲

/option 則為選項示範程式</t>
<t tx="amd.20160308205930.1">@app.route('/fileuploadform')
def fileuploadform():
    '''
    if not session.get('logged_in'):
        #abort(401)
        return redirect(url_for('login'))
    '''
    return "&lt;h1&gt;file upload&lt;/h1&gt;"+'''
  &lt;script src="/static/jquery.js" type="text/javascript"&gt;&lt;/script&gt;
  &lt;script src="/static/axuploader.js" type="text/javascript"&gt;&lt;/script&gt;
  &lt;script&gt;
  $(document).ready(function(){
  $('.prova').axuploader({url:'fileaxupload', allowExt:['jpg','png','gif','7z','pdf','zip','flv','stl','swf'],
  finish:function(x,files)
{
    alert('All files have been uploaded: '+files);
},
  enable:true,
  remotePath:function(){
  return 'downloads/';
  }
  });
  });
  &lt;/script&gt;
  &lt;div class="prova"&gt;&lt;/div&gt;
  &lt;input type="button" onclick="$('.prova').axuploader('disable')" value="asd" /&gt;
  &lt;input type="button" onclick="$('.prova').axuploader('enable')" value="ok" /&gt;
  &lt;/section&gt;&lt;/body&gt;&lt;/html&gt;
  '''
</t>
<t tx="amd.20160308210121.1">@app.route('/fileaxupload', methods=['POST'])
# ajax jquery chunked file upload for flask
def fileaxupload():
    '''
    if not session.get('logged_in'):
        #abort(401)
        return redirect(url_for('login'))
    '''
    # need to consider if the uploaded filename already existed.
    # right now all existed files will be replaced with the new files
    filename = request.args.get("ax-file-name")
    flag = request.args.get("start")
    if flag == "0":
        file = open(data_dir+"downloads/"+filename, "wb")
    else:
        file = open(data_dir+"downloads/"+filename, "ab")
    file.write(request.stream.read())
    file.close()
    return "files uploaded!"

    
    </t>
<t tx="amd.20160308213741.1">@language python
@tabwidth -4
import os
# 確定程式檔案所在目錄, 在 Windows 有最後的反斜線
_curdir = os.path.join(os.getcwd(), os.path.dirname(__file__))
# 設定在雲端與近端的資料儲存目錄
if 'OPENSHIFT_REPO_DIR' in os.environ.keys():
    # 表示程式在雲端執行
    data_dir = os.environ['OPENSHIFT_DATA_DIR']
    static_dir = os.environ['OPENSHIFT_REPO_DIR']+"/static"
else:
    # 表示程式在近端執行
    data_dir = _curdir + "/local_data/"
    static_dir = _curdir + "/static"
@others</t>
<t tx="amd.20160308213813.1">class Init(object):
    @others
</t>
<t tx="amd.20160308213813.2">def __init__(self):
    # hope to create downloads and images directories　
    if not os.path.isdir(data_dir+"downloads"):
        try:
            os.makedirs(data_dir+"downloads")
        except:
            print("mkdir error")
    if not os.path.isdir(data_dir+"images"):
        try:
            os.makedirs(data_dir+"images")
        except:
            print("mkdir error")


</t>
<t tx="amd.20160308215931.1">@app.route('/downloads/&lt;path:filename&gt;', methods=['GET', 'POST'])
def download(filename):
    #return send_from_directory(download_dir, filename=filename, as_attachment=True)
    return send_from_directory(download_dir, filename=filename)
    


</t>
</tnodes>
</leo_file>
