from flask import Flask,flash,redirect,request,url_for,render_template,session,send_file,abort
from flask_session import Session
from flask_mysqldb import MySQL
from sdmail import sendmail
import random
from key import *
import io
import os
from otp import genotp

from itsdangerous import URLSafeTimedSerializer
from stoken import token 
from io import BytesIO
app=Flask(__name__)
app.secret_key='876@#^%jh'
app.config['SESSION_TYPE']='filesystem'   
app.config['MYSQL_HOST']='localhost'
app.config['MYSQL_USER']='root'
app.config['MYSQL_PASSWORD']='admin'
app.config['MYSQL_DB']='recipy'
Session(app)
mysql=MySQL(app)
path = os.path.join(app.root_path,'static')
if not os.path.exists(path):
    os.makedirs(path,exist_ok=True)
@app.route('/')
def index():
    return render_template('index.html')
@app.route('/registration',methods=['GET','POST'])
def register():
    if request.method=='POST':
        name=request.form['name']
        email=request.form['email']
        password=request.form['password']
        gender=request.form['gender']
        cursor=mysql.connection.cursor()
        cursor.execute('select name from details')
        count=cursor.fetchall()
        cursor.execute('SELECT email from details')
        count1=cursor.fetchall()
        if count==1:
            flash('username already in use')
            return render_template('register.html')
        elif count1==1:
            flash('Email already in use')
            return render_template('register.html')
        data={'name':name,'password':password,'email':email,'gender':gender}
        subject='Email Confirmation'
        body=f"Thanks for signing up\n\nfollow this link for further steps-{url_for('confirm',token=token(data,salt=salt),_external=True)}"
        sendmail(to=email,subject=subject,body=body)
        flash('Confirmation link sent to mail')
        return redirect(url_for('login'))
    return render_template('register.html')

@app.route('/confirm/<token>')
def confirm(token):
    try:
        serializer=URLSafeTimedSerializer(secret_key)
        data=serializer.loads(token,salt=salt,max_age=180)
    except Exception as e:
        #print(e)
        return 'Link Expired register again'
    else:
        cursor=mysql.connection.cursor()
        name=data['name']
        cursor.execute('select count(*) from details where name=%s',[name])
        count=cursor.fetchone()[0]
        if count==1:
            cursor.close()
            flash('You are already registerterd!')
            return redirect(url_for('login'))
        else:
            cursor.execute('insert into details values(%s,%s,%s,%s)',[data['name'],data['email'],data['password'],data['gender']])
            mysql.connection.commit()
            cursor.close()
            flash('Details registered!')
            return redirect(url_for('login'))
@app.route('/login',methods=['GET','POST'])
def login():
        if request.method=='POST':
            print(request.form)
            name=request.form['name']
            password=request.form['password']
            cursor=mysql.connection.cursor()
            cursor.execute('select count(*) from details where name=%s and password=%s',[name,password])
            count=cursor.fetchone()[0]
            if count==0:
                print(count)
                flash('Invalid username or password')
                return render_template('login.html')
            else:
                session['user']=name
                return redirect(url_for('home'))
        return render_template('login.html')
@app.route('/home',methods=['GET','POST'])
def home():
        cursor=mysql.connection.cursor()
        cursor.execute('select * from blogs')
        data=cursor.fetchall()
        cursor.close()
        return render_template('home.html',data=data)
    
@app.route('/logout')
def logout():
    if session.get('user'):
        session.pop('user')
        return redirect(url_for('home'))
    else:
        flash('already logged out')
        return redirect(url_for('login'))
@app.route('/blogview',methods=['GET','POST'])
def blogview2():
    if session.get('user'):
        if request.method=='POST':
            id1=genotp()
            title=request.form['title']
            description=request.form['description']
            Categories= request.form['Categories']
            image=request.files['image']
            cursor=mysql.connection.cursor()
            name=session.get('user')
            filename=id1+'.jpg'
            cursor.execute('insert into blogs(name,title,description,Categories,imageid) values(%s,%s,%s,%s,%s)',[name,title,description,Categories,id1])
            mysql.connection.commit()
            path=os.path.join(app.root_path,'static')
            image.save(os.path.join(path,filename))
            cursor.close()
            flash(f'{title} added successfully')
            return redirect(url_for('home'))
        return render_template('blogview.html')
    else:
        return redirect(url_for('login'))
@app.route('/edit/<blogid>',methods=['GET','POST'])
def edit(blogid):
    if session.get('user'):
        cursor=mysql.connection.cursor()
        cursor.execute('select title,description,Categories from blogs where blogid=%s',[blogid])
        data=cursor.fetchone()
        cursor.close()
        if request.method=='POST':
            title=request.form['title']
            description=request.form['description']
            Categories=request.form['Categories']
            cursor=mysql.connection.cursor()
            cursor.execute('update blogs set title=%s,description=%s,Categories=%s where blogid=%s',[title,description,Categories,blogid])
            mysql.connection.commit()
            cursor.close()
            flash('recipe edited successfully')
            return redirect(url_for('home')) 
        return render_template('edit.html',data=data)
    else:
        return redirect(url_for('login'))
@app.route('/delete/<blogid>')
def delete(blogid):
    cursor=mysql.connection.cursor()
    cursor.execute('select imageid from blogs where blogid=%s',[blogid])
    itemid=cursor.fetchone()[0]
    cursor.execute('delete from blogs where blogid=%s',[blogid])
    mysql.connection.commit()
    cursor.close()
    path=os.path.join(app.root_path,'static')
    filename=f"{itemid}.jpg"
    os.remove(os.path.join(path,filename))
    flash(' recipe deleted successfully')
    return redirect(url_for('home'))
@app.route('/viewmore/<blogid>')
def viewmore(blogid):
    cursor=mysql.connection.cursor()
    cursor.execute('select title,description,imageid from blogs where blogid=%s',[blogid])
    data=cursor.fetchone()
    cursor.close()
    return render_template('viewmore.html',data=data)
@app.route('/search',methods=['POST'])
def search():
    if request.method=="POST":
        name=request.form['search']
        cursor=mysql.connection.cursor()
        cursor.execute('select * from blogs where title=%s',[name])
        data=cursor.fetchall()
        cursor.close()
        return render_template('home.html',data=data)
@app.route('/Categories/<category>',methods=['GET','POST'])
def Categories(category):
    cursor=mysql.connection.cursor()
    cursor.execute('select * from blogs where Categories=%s',[category])
    data=cursor.fetchall()
    cursor.close()
    return render_template('home.html',data=data)
    
@app.route('/forget',methods=['GET','POST'])
def forget():
    if request.method=='POST':
        email=request.form['email']
        cursor=mysql.connection.cursor()
        cursor.execute('select count(*) from details where email=%s',[email])
        count=cursor.fetchone()[0]
        cursor.close()
        if count==1:
            cursor=mysql.connection.cursor()
            cursor.execute('SELECT email from details where email=%s',[email])
            status=cursor.fetchone()[0]
            cursor.close()
            subject='Forget Password'
            confirm_link=url_for('reset',token=token(email,salt=salt2),_external=True)
            body=f"Use this link to reset your password-\n\n{confirm_link}"
            sendmail(to=email,body=body,subject=subject)
            flash('Reset link sent check your email')
            return redirect(url_for('login'))
        else:
            flash('Invalid email id')
            return render_template('forgot.html')
    return render_template('forgot.html')


@app.route('/reset/<token>',methods=['GET','POST'])
def reset(token):
    try:
        serializer=URLSafeTimedSerializer(secret_key)
        email=serializer.loads(token,salt=salt2,max_age=180)
    except:
        abort(404,'Link Expired')
    else:
        if request.method=='POST':
            newpassword=request.form['npassword']
            confirmpassword=request.form['cpassword']
            if newpassword==confirmpassword:
                cursor=mysql.connection.cursor()
                cursor.execute('update details set password=%s where email=%s',[newpassword,email])
                mysql.connection.commit()
                flash('Reset Successful')
                return redirect(url_for('login'))
            else:
                flash('Passwords mismatched')
                return render_template('newpassword.html')
        return render_template('newpassword.html')


app.run(debug=True,use_reloader=True)
