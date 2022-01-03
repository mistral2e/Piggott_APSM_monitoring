def DisplayAndCut(df1,absz,start1,end1,start2,end2):
    df1['index_copy']=df1.index
    #cut1
    df1.drop(df1[:start1].index,inplace=True)    # lösche alle bis start1
    df1.drop(df1.tail(end1).index,inplace=True)  #lösche Anzahl end1 letzte Einträge
    #plot
    fig, axs = plt.subplots(1, 2,figsize=(15,5))
    ax=axs[0]
    ax.scatter(df1[absz],df1['cc_diff'])
    ax.axvline(start2,color='r')
    ax.axvline(start2+end2,color='r')
    #cut2
    filter=(df1[absz]<start2)|(df1[absz]>(start2+end2)) #lösche alle außer Bereich start2 bis strat2+end2
    df1.drop(df1.loc[filter].index,inplace=True)
    df1.reset_index(inplace = True,drop = True) 
    df1['index_copy']=df1.index 
    #plot2
    ax=axs[1]
    ax.scatter(df1[absz],df1['cc_diff'],s=0.8)
    return df1
    
def DisplayAndCutMult(df1,absz,start1,end1,start2,end2,inputs):
    df1['index_copy']=df1.index
    #cut1
    df1.drop(df1[:start1].index,inplace=True)    # lösche alle bis start1
    df1.drop(df1.tail(end1).index,inplace=True)  #lösche Anzahl end1 letzte Einträge
    #plot
    fig, axs = plt.subplots(1, 2,figsize=(15,5))
    ax=axs[0]
    for i1 in inputs:
        filter=(df1['input']==i1)
        ax.scatter(df1.loc[filter,absz],df1.loc[filter,'cc_diff'],label=input_conn.loc[i1,'Sensor'],s=0.8)
    ax.axvline(start2,color='r')
    ax.axvline(start2+end2,color='r')
    ax.set_xlabel(absz)
    ax.set_ylabel("cc_diff")
    ax.legend()
    #cut2
    filter=(df1[absz]<start2)|(df1[absz]>(start2+end2)) #lösche alle außer Bereich start2 bis strat2+end2
    df1.drop(df1.loc[filter].index,inplace=True)
    df1.reset_index(inplace = True,drop = True) 
    df1['index_copy']=df1.index 
    #plot2
    ax=axs[1]
    for i1 in inputs:
        filter=(df1['input']==i1)
        ax.scatter(df1.loc[filter,absz],df1.loc[filter,'cc_diff'],label=input_conn.loc[i1,'Sensor'],s=1.8)
    ax.legend()
    return df1

def PlotMult(df,xaxis,yaxis,faktor,inputs,size1):
    df['index_copy']=df.index
    fig, axs = plt.subplots(1, len(inputs),figsize=size1)
    for i2,inp2 in enumerate(inputs):
        if(len(inputs)==1):
            ax=axs
        else:
            ax=axs[i2]
        ax.scatter(df.loc[df['input']==inp2,xaxis],df.loc[df['input']==inp2,yaxis]/faktor,label=input_conn.loc[inp2,'Sensor'],s=6,c='r')
        ax.set_xlabel(xaxis)
        ax.set_ylabel(yaxis +' 10^'+ str(round(m.log(faktor,10),0)))
        ax.legend()
