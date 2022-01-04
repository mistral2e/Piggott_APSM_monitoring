def FFT_ASCIIscope(scope_file,zeroN,zeroNrel):
    scope=pd.read_csv(scope_file,sep=",",skiprows=[0],names=['time','sig1'],header=0)
    N=scope.shape[0] #samples
    totalN = N+zeroN + zeroNrel*N
    y=scope['sig1']
    T0=scope['time'].iloc[[0,-1]].diff().max()
    delta_f=1/T0
    f_max=(1/T0)*N//2
    yf = np.fft.fft(y,totalN)[:totalN//2]
    yf=1.0/N * np.abs(yf) #Absolute and Normalization
    xf = np.linspace(0.0, f_max,totalN//2 )
    print(N,totalN,xf[1],xf.shape,yf.shape)
    return xf,yf, delta_f, totalN

def FFT_ASCIIscope_div(scope_file,zeroN,zeroNrel,div,window):
    scope=pd.read_csv(scope_file,sep=",",skiprows=[0],names=['time','sig1'],header=0)
    scope=scope[:scope.shape[0]//div]
    N=scope.shape[0] #samples
    totalN = N+zeroN + zeroNrel*N
    y=scope['sig1']
    if(window=='blackman'):
        w=np.blackman(N)
        y=w*y
    T0=scope['time'].iloc[[0,-1]].diff().max()
    delta_f=1/T0
    f_max=(1/T0)*N//2
    yf = np.fft.fft(y,totalN)[:totalN//2]
    yf=1.0/N * np.abs(yf) #Absolute and Normalization
    xf = np.linspace(0.0, f_max,totalN//2 )
    print(N,totalN,xf[1],xf.shape,yf.shape)
    return xf,yf, delta_f, totalN

def FFT_ASCIIscope_mov2(scope_file,**kwargs):
    zeroN=kwargs.get('zeroN', 0)
    zeroNrel=kwargs.get('zeroNrel', None)
    start=kwargs.get('ti',0)
    end=kwargs.get('tf',100)
    window=kwargs.get('window','blackman')
    scope=pd.read_csv(scope_file,sep=",",skiprows=[0],names=['time','sig1'],header=0)
    filter=(scope['time']>start)&(scope['time']<end)
    scope=scope.loc[filter]
    N=scope.shape[0] #samples
    totalN = N+zeroN + zeroNrel*N
    y=scope['sig1']
    if(window=='blackman'):
        w=np.blackman(N)
        y=w*y
    T0=scope['time'].iloc[[0,-1]].diff().max()
    delta_f=1/T0
    f_max=(1/T0)*N//2
    yf = np.fft.fft(y,totalN)[:totalN//2]
    yf=1.0/N * np.abs(yf) #Absolute and Normalization
    xf = np.linspace(0.0, f_max,totalN//2 )
    print(N,totalN,xf[1],xf.shape,yf.shape)
    return xf,yf, delta_f, totalN

import matplotlib.ticker as ticker
def plotfft2(df_b1,**kwargs):
    dtick = kwargs.get('dtick',10)
    kontrast = kwargs.get('kontrast', None)
    m = kwargs.get('m', None)
    n = kwargs.get('n', None)
    sp = kwargs.get('sp', 10)
    plot=kwargs.get('plot',0)
    file1=kwargs.get('file',None)
    xf1=kwargs.get('xf',None)
    qual1=kwargs.get('qual',900)
    labels=kwargs.get('labels',None)
    #figsize=)
    if((m is not None)&(n is not None)):
        filter=(df_b1['freq']>m)&(df_b1['freq']<n)
    else:
        filter=df_b1['freq']<10**6
    mv0=df_b1['freq'].diff().mean()/8
    if(plot>0):
        fig, axo = plt.subplots(1,1,figsize=kwargs.get('figsize',(15, 10))) ;ax1=axo;ax2=axo;axb=[0];axb[0]=axo;
    else:
           if(kwargs.get('hv',1)==1):
               fig, axo = plt.subplots(2,1,figsize=kwargs.get('figsize',(15, 10))) ;ax1=axo[0];ax2=axo[1];
           else:
               fig, axo = plt.subplots(1,2,figsize=kwargs.get('figsize',(15, 10))) ;ax1=axo[0];ax2=axo[1];
           axb=axo
    for index, row in scope_dat.iterrows():
        if(index in df_b1):
            if(row['Symbol']=='Stator_Inclined'):
                c1='C0';t1='inclied';lw1=3*0.5;ls1='-.'
                s1=sp;mv=+mv0
                m1='P'
                if(kontrast is not None):
                   c1='red'
            if(row['Symbol']=='Rotor_Deviated'):
                c1='C2';t1='inclied';lw1=3*0.5;ls1='-.'
                s1=sp;mv=+mv0
                m1='x'
                if(kontrast is not None):
                   c1='red'
            if(row['Symbol']=='parallel'):
                c1='C1';t1='parallel';lw1=1;ls1='-'
                s1=sp;mv=-mv0
                m1='o'
                if(kontrast is not None):
                   c1='blue'
            if(labels==None):
                label="#"+str(index+1)+" "+row['Symbol'] #+str(round(row['f'],2))
            else: label=labels[index]       
            #ax.semilogy(df_b1.loc[m:n,'index_copy'],df_b1.loc[m:n,index],color=c1,lw=lw1,ls=ls1,label=label)
            if((plot==1)|(plot==0)):
                if(xf1 is not None):
                    ax1.semilogy(xf1.loc[filter,index],df_b1.loc[filter,index],lw=lw1,ls=ls1,label=label,color=c1)
                else:
                    ax1.semilogy(df_b1.loc[filter,'freq'],df_b1.loc[filter,index],lw=lw1,ls=ls1,label=label,color=c1)
                ax1.set_ylabel("Amplitude X norm. [V] (log. Skala)")
            #ax2.plot(df_b1.loc[m:n,'index_copy'],df_b1.loc[m:n,index],lw=lw1,ls=ls1,label=label)
            if((plot==2)|(plot==0)):
                ax2.scatter(df_b1.loc[filter,'freq']+mv,df_b1.loc[filter,index],label=label,s=s1,marker=m1)
                ax2.set_ylabel("Amplitude X norm. [V] (lin. Skala)")
    for ax in axb:
        if(xf1 is None):
            ax.set_xlabel("Frequenz f [Hz]")
        ax.legend()
        ax.grid(True)
        if((m is not None)&(n is not None)):
            ax.xaxis.set_major_locator(ticker.MultipleLocator(dtick))
    if(file1 != None):
        plt.savefig(file1+".png",qual=qual1)
        plt.savefig(file1+".eps")
    plt.show()
