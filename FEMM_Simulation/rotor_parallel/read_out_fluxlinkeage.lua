function modulo(A,B) 
C=0;zahler=0
for i=0,A,B do
zahler = zahler + 1;C=i;
end
return (zahler-1), (A-C) -- ganzzahliges Divisonsergebnis, Rest
end


sim_name = "2F12P_V2_0Deg"
showconsole()
print("Start")
pi=PI

result="i;I;V;Phi"
fp=openfile(sim_name .. "_linkage.txt","a")
write(fp,result,"\n")
closefile(fp);


for i=90,90+360/12*2,1
-- for i=90,120,10
do

a=sim_name .. i
print(a)
open(a..".ans")
mo_setfocus(a..".ans")
print(mo_getcircuitproperties("H"))
a,b,c =  mo_getcircuitproperties("H")
result=i .. ";" .. a ..";" .. b .. ";" .. c
print(result)

fp=openfile(sim_name .. "_linkage.txt","a")
write(fp,result,"\n")
closefile(fp);

mo_close()
end