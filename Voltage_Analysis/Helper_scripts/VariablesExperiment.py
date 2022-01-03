import pandas as pd
import os

folder1="./Helper_scripts/"
file_csv="BokuTurbineDaten.csv"
file1=os.path.join(folder1,file_csv)
df=pd.read_csv(file1,sep=";")

n_N_rpm=df.loc[df["Symbol"]=="n_N1","Value"].values[0];
nNrpm=n_N_rpm
#print(type(n_N_rpm))
n_N=n_N_rpm/60
nNs=n_N
p=df.loc[df["Symbol"]=="2p","Value"].values[0]/2
f_N=n_N*p
def VariablesExperiment(date):
    #setting=[20210319,]
    #if(date in setting):
    global lines, linesm1,uC_clock_speed,input_conn,scope_dat
    lines=df.loc[(df["Symbol"]=="lines")&(df["Date"]==date),"Value"].values[0]
    linesm1=lines-1
    uC_clock_speed=df.loc[(df["Symbol"]=="uC_clock_speed")&(df["Date"]==date),"Value"].values[0]*10**6
    if(date>20210421):
        input_conn=df.loc[(df["Description0"]=="Input")&(df["Date"]==date),["Description1","Description2"]]
        input_conn.rename(columns = {'Description1':'Input', 'Description2':'Sensor',},inplace=True)
        input_conn['Input']=pd.to_numeric(input_conn['Input'])
        input_conn.set_index("Input",inplace=True)
        scope_dat=df.loc[(df["Part"]=="scope")&(df["Date"]==date)&(df["Description0"]=="Aufnahme"),].copy()
        scope_dat.rename(columns = {'Description3':'ScopeFile',},inplace=True)
        scope_dat.rename(columns = {'Description2':'SerialFile',},inplace=True)
        scope_dat.reset_index(inplace = True,drop = True) 

def nf(**kwargs):
    f_el=kwargs.get('f',None)
    returnSym=kwargs.get('ret',None)
    if(returnSym=='n_rpm'):
        n_rpm=f_el/(2*p)*60
        print("f_el_"+str(f_el)+"und 2p="+str(2*p)+"ergibt n="+str(n_rpm)+" rpm")
        return n_rpm


#VariablesExperiment(20210527)
