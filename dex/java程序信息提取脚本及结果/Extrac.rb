#!/usr/bin/ruby -w 
require 'find'

file = File.open("functest.txt")
resultfile = File.new("result.txt","w")
line=file.readlines
classSizeStr = line.join.scan(/[c][l][a][s][s][_][d][e][f][s][_][s][i][z][e]\s\s\s\s\s\:\s[0-9]+/)
classSize = classSizeStr.join.scan(/[0-9]+/)
resultfile.puts "类个数：" + classSize.join.to_s
zI=0
zDMcount=[]
zVMcount=[]
zMAX=100

#分析类首部，提取类的Header
for zJ in 0..classSize.join.to_i-1
 #找到类首部
 notFound=true
 while notFound && zI<line.size
  classHeaderStr = line[zI].scan(/[C][l][a][s][s]\s[#][0-9]+\s[h][e][a][d][e][r][:]/)
  if classHeaderStr.join.scan(/[C][l][a][s][s]/).join.to_s=="Class".to_s
   break
  end
  zI = zI + 1
 end
 resultfile.puts classHeaderStr.join.gsub(/[h][e][a][d][e][r]/,"")
 #分析类首部，提取直接方法数与虚方法数
 zDMcount[zJ] = -1
 zVMcount[zJ] = -1

 zI = zI + 1
 notFound=true
 while notFound && zI<line.size
  directMethodSizeStr = line[zI].scan(/[d][i][r][e][c][t][_][m][e][t][h][o][d][s][_][s][i][z][e]\s[:]\s[0-9]+/)
  if directMethodSizeStr.join.scan(/[d][i][r][e][c][t][_][m][e][t][h][o][d][s][_][s][i][z][e]/).join.to_s=="direct_methods_size".to_s
   break
  end
  zI = zI + 1
 end
 zDMcount[zJ] = directMethodSizeStr.join.scan(/[0-9]+/).join.to_i

 #指针加1，直接输出下一行的virtual_methods_size
 zI = zI + 1
 zVMcount[zJ] = line[zI].scan(/[0-9]+/).join.to_i
 resultfile.puts "  direct_methods: " + zDMcount[zJ].to_s
 resultfile.puts "  virtual_methods: " + zVMcount[zJ].to_s

 #分析类，找到Class #行, 输出path
 notFound=true
 while notFound && zI<line.size
  classInfo = line[zI].scan(/^[C][l][a][s][s].*[-]/)
  if classInfo.join.scan(/^[C][l][a][s][s]/).join.to_s=="Class".to_s
   break
  end
  zI = zI + 1
 end
 zI = zI + 1

 classLocationStr = line[zI].scan(/\s\s[C][l][a][s][s]\s[d][e][s][c][r][i][p][t][o][r].*/) 
 classlocation = classLocationStr.join.scan(/['].*[']/)
 resultfile.puts "  路径: "+classlocation.join.gsub(/[']/,"").gsub(/\;/,"")
 zI = zI + 1

 #分析直接方法，以Direct methods行作为导引
 notFound=true
 while notFound && zI<line.size
  directMethodsStr = line[zI].scan(/\s\s[D][i][r][e][c][t]\s[m][e][t][h][o][d][s].*[-]/)
  if directMethodsStr.join.scan(/\s\s[D][i][r][e][c][t]\s[m][e][t][h][o][d][s]/).join.to_s=="  Direct methods".to_s
   break
  end
  zI = zI + 1
 end
 resultfile.puts directMethodsStr
 zI = zI + 1

# puts "zDMcount[zJ] = " + zDMcount[zJ].to_s
 zD = 0
 codeLines = Array.new(zMAX, "")
 mapLines = Array.new(zMAX, "")
 while zI < line.size
  methodsPath = line[zI].scan(/\s\s\s\s\#[0-9]+[\s]+\:.*/)
  if methodsPath.join.scan(/\s\s\s\s\#/).join.to_s=="    #".to_s
   resultfile.puts methodsPath.join.gsub("(","").gsub(";)","")
   zI=zI+1
   methodnameStr = line[zI].scan(/\s\s\s\s\s\s[n][a][m][e].*/) 
   methodnameString = methodnameStr.join.gsub(/\s\s\s\s\s\s[n][a][m][e]/,"\s\s\s\s方法名").gsub(/\'/,"")
   resultfile.puts methodnameString
   codeLinesCount = 0
   mapLinesCount = 0
  else
   methodEndMark = line[zI].scan(/\s\s\s\s\s\s[l][o][c][a][l][s].*/)
   if methodEndMark.join.scan(/\s\s\s\s\s\s[l][o][c][a][l][s]/).join.to_s=="      locals".to_s    
    i=0
    j=0
    currentLine = mapLines[0].to_s.scan(/[l][i][n][e][=][0-9]+/).to_s.gsub("line=","")
    
    zHasWritten = 0
    if codeLinesCount > 0
    resultfile.puts  "    调用方法列表    : "
    resultfile.puts "	行号	目标地址      字节码地址	被调方法路径			被调方法名"
    end
    while i < codeLinesCount do
     destAddrOfInvocationInfo = codeLines[i].scan(/\s\s\s\s\s\s\s\s[0][x][0-9a-z]{4}/).to_s.gsub("\s\s\s\s\s\s\s\s","")
     while j < mapLinesCount do
      destAddrOfMapInfo = mapLines[j].to_s.scan(/\s\s\s\s\s\s\s\s[0][x][0-9a-z]{4}/).to_s.gsub("\s\s\s\s\s\s\s\s","")
      if destAddrOfInvocationInfo > destAddrOfMapInfo
       currentLine = mapLines[j].to_s.scan(/[l][i][n][e][=][0-9]+/).to_s.gsub("line=","")
       j = j + 1
      else
       if destAddrOfInvocationInfo == destAddrOfMapInfo
        currentLine = mapLines[j].to_s.scan(/[l][i][n][e][=][0-9]+/).to_s.gsub("line=","")
        resultfile.puts "	" + currentLine.to_s.gsub("\"","").gsub("[","").gsub("]","") + "	" + codeLines[i].to_s
        zHasWritten = zHasWritten + 1
        break
       else
        resultfile.puts "	" + currentLine.to_s.gsub("\"","").gsub("[","").gsub("]","") + "	" + codeLines[i].to_s
        zHasWritten = zHasWritten + 1
        break
       end
      end
     end#while j
     if zHasWritten == i
      resultfile.puts "	" + currentLine.to_s.gsub("\"","").gsub("[","").gsub("]","") + "	" + codeLines[i].to_s
      zHasWritten = zHasWritten + 1
     end
     i = i + 1
    end#while i

    zD = zD + 1
    if zD == zDMcount[zJ]
     break
    end
   else#methodEndMark
    zEntryAddressStr = line[zI].scan(/.*\|\[.*/)
    if zEntryAddressStr.join.scan(/\|\[/).join.to_s == "|[".to_s
     zEntryAddress = zEntryAddressStr.join.scan(/[0-9a-z]{6}\:/)
     resultfile.puts  "    入口地址        : " + zEntryAddress.join.to_s.gsub(/\:/,"")
    end

    explaincodeline = line[zI].scan(/.*\:.*\|[0-9a-z]{4}\:\s[i][n][v][o][k][e].*/)
    if explaincodeline.join.scan(/[i][n][v][o][k][e]/).join.to_s == "invoke".to_s
     explaincode = explaincodeline.join.gsub(/\:\s.*\|/,"\s\s\s\s\s\s\s\s0x").gsub(/\:.*\,\s/,"		").gsub(/\;\./,"\s\s		").gsub(/\/\/.*/,"")
     codeLines[codeLinesCount] = explaincode
     codeLinesCount = codeLinesCount + 1
    end
    sourceline = line[zI].scan(/.*[a-z]{4}\=.*/)
    if sourceline.join.scan(/[0][x]/).join.to_s == "0x".to_s
     mapLines[mapLinesCount] = sourceline
     mapLinesCount = mapLinesCount + 1
    end
   end#methodEndMark
  end#methodsPath

  zI = zI + 1
  
 end #EndofAnalyzationOfDirectMethods



 #分析虚方法，以Virtual methods行作为导引
 notFound=true
 while notFound && zI<line.size
  virtualMethodsStr = line[zI].scan(/\s\s[V][i][r][t][u][a][l]\s[m][e][t][h][o][d][s].*[-]/)
  if virtualMethodsStr.join.scan(/\s\s[V][i][r][t][u][a][l]\s[m][e][t][h][o][d][s]/).join.to_s=="  Virtual methods".to_s
   break
  end
  zI = zI + 1
 end
 resultfile.puts virtualMethodsStr

 zI = zI + 1

 zV = 0
 codeLines = Array.new(zMAX, "")
 mapLines = Array.new(zMAX, "")
 while zI < line.size
  methodsPath = line[zI].scan(/\s\s\s\s\#[0-9]+[\s]+\:.*/)
  if methodsPath.join.scan(/\s\s\s\s\#/).join.to_s=="    #".to_s
   resultfile.puts methodsPath
   zI=zI+1
   methodnameStr = line[zI].scan(/\s\s\s\s\s\s[n][a][m][e].*/) 
    methodnameString = methodnameStr.join.gsub(/\s\s\s\s\s\s[n][a][m][e]/,"\s\s\s\s方法名").gsub(/\'/,"")
   resultfile.puts methodnameString
   codeLinesCount = 0
   mapLinesCount = 0
  else
   methodEndMark = line[zI].scan(/\s\s\s\s\s\s[l][o][c][a][l][s].*/)
   if methodEndMark.join.scan(/\s\s\s\s\s\s[l][o][c][a][l][s]/).join.to_s=="      locals".to_s
    i=0
    j=0
    currentLine = mapLines[0].to_s.scan(/[l][i][n][e][=][0-9]+/).to_s.gsub("line=","")
    zHasWritten = 0
    if codeLinesCount > 0
     resultfile.puts  "    调用方法列表    : "
     resultfile.puts "	行号	目标地址      字节码地址	被调方法路径			被调方法名"
    end
    while i < codeLinesCount do
     destAddrOfInvocationInfo = codeLines[i].scan(/\s\s\s\s\s\s\s\s[0][x][0-9a-z]{4}/).to_s.gsub("\s\s\s\s\s\s\s\s","")
     while j < mapLinesCount do
      destAddrOfMapInfo = mapLines[j].to_s.scan(/\s\s\s\s\s\s\s\s[0][x][0-9a-z]{4}/).to_s.gsub("\s\s\s\s\s\s\s\s","")
      if destAddrOfInvocationInfo > destAddrOfMapInfo
       currentLine = mapLines[j].to_s.scan(/[l][i][n][e][=][0-9]+/).to_s.gsub("line=","")
       j = j + 1
      else
       if destAddrOfInvocationInfo == destAddrOfMapInfo
        currentLine = mapLines[j].to_s.scan(/[l][i][n][e][=][0-9]+/).to_s.gsub("line=","")
        resultfile.puts "	" + currentLine.to_s.gsub("\"","").gsub("[","").gsub("]","") + "	" + codeLines[i].to_s
        zHasWritten = zHasWritten + 1
        break
       else
        resultfile.puts "	" + currentLine.to_s.gsub("\"","").gsub("[","").gsub("]","") + "	" + codeLines[i].to_s
        zHasWritten = zHasWritten + 1
        break
       end
      end
     end
     if zHasWritten == i
      resultfile.puts "	" + currentLine.to_s.gsub("\"","").gsub("[","").gsub("]","") + "	" + codeLines[i].to_s
      zHasWritten = zHasWritten + 1
     end
     i = i + 1
    end

    zV = zV + 1
    if zV == zVMcount[zJ]
     break
    end
   else
    zEntryAddressStr = line[zI].scan(/.*\|\[.*/)
    if zEntryAddressStr.join.scan(/\|\[/).join.to_s == "|[".to_s
     zEntryAddress = zEntryAddressStr.join.scan(/[0-9a-z]{6}\:/)
     resultfile.puts  "    入口地址        : " + zEntryAddress.join.to_s.gsub(/\:/,"")
    end
    explaincodeline = line[zI].scan(/.*\:.*\|[0-9a-z]{4}\:\s[i][n][v][o][k][e].*/)
    if explaincodeline.join.scan(/[i][n][v][o][k][e]/).join.to_s == "invoke".to_s
     explaincode = explaincodeline.join.gsub(/\:\s.*\|/,"\s\s\s\s\s\s\s\s0x").gsub(/\:.*\,\s/,"		").gsub(/\;\./,"\s\s		").gsub(/\/\/.*/,"")
     codeLines[codeLinesCount] = explaincode
     codeLinesCount = codeLinesCount + 1
    end
    sourceline = line[zI].scan(/.*[a-z]{4}\=.*/)
    if sourceline.join.scan(/[0][x]/).join.to_s == "0x".to_s
     mapLines[mapLinesCount] = sourceline
     mapLinesCount = mapLinesCount + 1
    end
   end
  end

  zI = zI + 1
   
 end #EndofAnalyzationOfVirtualMethods

end #EndofClassAnalyzation

