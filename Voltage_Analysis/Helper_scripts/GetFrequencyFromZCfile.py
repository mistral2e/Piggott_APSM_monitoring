def getZCDataAfterTrigger(file,inputfilter,time):
    # Read File
    df=pd.read_csv(file,sep=";")
    df.dropna(axis=1,inplace=True)
    df.dropna(axis=0,inplace=True)
    display(df.head(5))
    if(inputfilter!=0):
        filter=(df['input']==12)|(df['input']==inputfilter)
        df.drop(df.loc[~filter].index,inplace=True)
        df.reset_index(inplace = True,drop = True) 
    df=OverflowCC_local(df)
    dfo=df.copy()
    #Cut part
    df=dfo.copy()
    triggerIdx=df.loc[df['input']==12,:].index[0]
    display(df[triggerIdx-5:triggerIdx+10])
    df['index_copy']=df.index
    scopeEndtime_cc=df.loc[triggerIdx,'cc_total']+uC_clock_speed*time
    filter=(df['index_copy']>triggerIdx)&(df['cc_total']<scopeEndtime_cc)
    scopeEnd_idx=df.loc[filter,'index_copy'].max()
    df1=DisplayAndCut(df,'index_copy',0,0,triggerIdx,scopeEnd_idx-triggerIdx)
    return df1

def getfrequency(df1,inputnr,val1):
    ZC_cc_mean=df1.loc[(df1['input']==inputnr),'cc_total'].diff().mean()
    ZC_sek_mean=(ZC_cc_mean/uC_clock_speed)
    f_mean=1/2*(1/ZC_sek_mean)
    return f_mean
