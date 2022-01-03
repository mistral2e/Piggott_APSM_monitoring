def OverflowCC():
    global df
    df['cc_overflow_python']=9999
    for i in range(10):
        #counter=0
        counter=df.loc[0,'cc_overflow_count']
        cc_old=df.loc[0,'ESP_CC']
        for index, row in df.loc[df['input']==i,['cc_overflow_python','ESP_CC']].iterrows(): #verbessern, sodass nur 'lines' in RAM
            cc_new=row['ESP_CC']
            if(cc_new<cc_old):
                counter+=1
            df.loc[index,'cc_overflow_python']=counter
            cc_old=cc_new
    #handle Trigger
    for index, row in df.loc[df['input']==12,['cc_overflow_python','ESP_CC']].iterrows():
        df.loc[index,'cc_overflow_python']=df.loc[index-1,'cc_overflow_python']
    filter=df['cc_overflow_count']!=df['cc_overflow_python']
    if(df[filter].size!=0):
        print("Error ESP vs Python Overflow count")
        display(df[filter])
    df['cc_total']=df['ESP_CC']+(df['cc_overflow_python']*(2**32))
    for i in range(10):
        df.loc[df['input']==i,'cc_diff']=df.loc[df['input']==i,'cc_total'].diff()
    df['count']=8888
    for i in range(20):
        l1=df.loc[df['input']==i].shape[0]
        df.loc[df['input']==i,'count']=np.arange(l1)+1

def OverflowCC_local(df):
    df['cc_overflow_python']=9999
    for i in range(10):
        #counter=0
        counter=df.loc[0,'cc_overflow_count']
        cc_old=df.loc[0,'ESP_CC']
        for index, row in df.loc[df['input']==i,['cc_overflow_python','ESP_CC']].iterrows(): #verbessern, sodass nur 'lines' in RAM
            cc_new=row['ESP_CC']
            if(cc_new<cc_old):
                counter+=1
            df.loc[index,'cc_overflow_python']=counter
            cc_old=cc_new
    #handle Trigger
    for index, row in df.loc[df['input']==12,['cc_overflow_python','ESP_CC']].iterrows():
        df.loc[index,'cc_overflow_python']=df.loc[index-1,'cc_overflow_python']
    filter=df['cc_overflow_count']!=df['cc_overflow_python']
    if(df[filter].size!=0):
        print("Error ESP vs Python Overflow count")
        display(df[filter])
    df['cc_total']=df['ESP_CC']+(df['cc_overflow_python']*(2**32))
    for i in range(10):
        df.loc[df['input']==i,'cc_diff']=df.loc[df['input']==i,'cc_total'].diff()
    df['count']=8888
    for i in range(20):
        l1=df.loc[df['input']==i].shape[0]
        df.loc[df['input']==i,'count']=np.arange(l1)+1
    return df
