function w_matrix = Track_to_eigenworm_weights(Track)

w_matrix = [];

eig_vec = N2_off_food_eigenworm;

for(k=1:size(Track.curvature_vs_body_position_matrix,1))
    for(i=1:6)
        w_matrix(i,k) = dot(eig_vec(:,i),Track.curvature_vs_body_position_matrix(k,:));
    end
end
    
maxval = abs(max(max(w_matrix)));
w_matrix = w_matrix./maxval;

return;
end

function eig_vec = N2_off_food_eigenworm

eig_vec = [
 -0.24888      0.1005    -0.25048    -0.39947   -0.066735     0.46025     0.36308     0.26766     0.25433     0.20731     0.16794     0.13597     0.11364    0.089599   -0.082579    -0.10322    -0.10638     -0.1102   -0.096905    -0.11228    -0.14599     -0.1268   -0.083176   -0.041278   -0.025596   -0.031019  -0.0017584  -0.0024954 -0.00028667   -0.001346   0.0028172   0.0011997   0.0015647  0.00055674 -0.00040609   0.0015242 -1.1578e-005  0.00021213  0.00073386  0.00065647  0.00061057  0.00072974  -0.0002485  -0.0004965   0.0002497 -0.00091133  -0.0015951   0.00020924  0.00041087  0.00029792
  -0.2571    0.095608    -0.21461    -0.28484   0.0044946      0.2186    0.084998   -0.005105   -0.047293    -0.10161    -0.14451    -0.21604    -0.27394    -0.22529     0.17318      0.1569     0.17346     0.19193     0.18496     0.21617     0.31454       0.302     0.24431     0.15108     0.13406     0.19962   0.0041389   0.0023527  -0.0059526   -0.019101   -0.042833   -0.014364   -0.016863  -0.0032536    0.010799  -0.0093031    0.0017614   0.0019492   -0.004983   0.0048941  -0.0037925   -0.021565    -0.01027   0.0032785  0.00076394   0.0026895   0.0044748   0.00072241    0.001627 -0.00085423
 -0.25393    0.083912    -0.17128    -0.17852    0.062155     0.01868    -0.11348    -0.17308    -0.20482    -0.23017    -0.23575    -0.25909    -0.20499    -0.10915    0.017631    0.012246   0.0069911   0.0072517   -0.018969   -0.043739     -0.1475    -0.21769    -0.26771    -0.22223    -0.26248    -0.46435  -0.0085347   0.0017371    0.027512    0.088191     0.18818    0.054162    0.066404    0.010739   -0.048209    0.035861   -0.0074621   -0.010558    0.021497   -0.025286     0.01007      0.1042    0.057754   -0.014486  -0.0067835   -0.005332  -0.0091239   -0.0052805  -0.0077102   0.0023159
 -0.24961    0.072864    -0.14255    -0.11994    0.091803   -0.068553     -0.1768    -0.19658    -0.20171    -0.19687    -0.17483    -0.12687    0.064385     0.16332    -0.18704    -0.14073    -0.10923    -0.13106    -0.13628    -0.16099    -0.19674     -0.1474   -0.042923    0.050883     0.15617     0.40416    0.015047   -0.002633   -0.040085    -0.14597    -0.35739   -0.096557    -0.11625   -0.026502    0.077821   -0.070192     0.014563    0.018518    -0.04844    0.054817   -0.024739    -0.24927    -0.14455    0.032353    0.016162   0.0081952    0.016222    0.0069958   0.0065546  -0.0075805
 -0.24542    0.063841    -0.12239   -0.090665     0.10478   -0.087056    -0.16286    -0.14225    -0.11337   -0.079733   -0.011641     0.13834     0.33644     0.32034    -0.19482   -0.091486   -0.048497   -0.043508   -0.027953 -0.00075364     0.10454     0.18562     0.22248     0.15129     0.11997    0.056657   -0.014636   0.0055459    0.019436     0.10296     0.34191    0.097033    0.089599    0.037209   -0.061289    0.075202      -0.0137   -0.016757    0.058638   -0.089885    0.050337     0.41235     0.24871    -0.04317   -0.024401   -0.012071     -0.0247   -0.0062462   0.0042883    0.010833
 -0.24057    0.055129   -0.098805   -0.057163     0.11839     -0.1064    -0.14756   -0.091255   -0.031886    0.038052     0.14427     0.30837     0.30408     0.13897    0.046982     0.10324    0.079562    0.093967     0.10877     0.13519     0.18804     0.13763    0.041125   -0.048814    -0.14544    -0.35053    -0.02281   -0.029749    0.012616    0.008868  -0.0060009   -0.027361    0.035166   -0.019221  -0.0041787   -0.017742   -0.0035383   -0.004107    -0.03116      0.1264    -0.07732    -0.49799    -0.31695    0.044191    0.028764     0.01314    0.030037    0.0081537   -0.013218  -0.0082951
 -0.23434     0.04373   -0.066042   -0.013063     0.13704    -0.13963    -0.14554   -0.056661    0.022221     0.11627     0.21281     0.28278     0.07108    -0.13504     0.23689     0.18748     0.11414    0.092957    0.075822    0.070666   -0.012662    -0.09867    -0.17472     -0.1271    -0.10181    0.044823    0.040703    0.046075   -0.019692   -0.069607    -0.46825   -0.085736    -0.19485   -0.034181    0.095883   -0.069661     0.020119    0.027772   -0.017363    -0.11351    0.067145     0.38215     0.25573    -0.02969   -0.017571  -0.0063637   -0.015574   -0.0058603    0.013511 -0.00035371
 -0.22598    0.028353   -0.027795     0.02962     0.15634    -0.16525     -0.1346   -0.018909    0.065971     0.15095      0.1967     0.13494    -0.13217    -0.26669     0.23826     0.10904    0.008771   -0.026969   -0.036458   -0.061401    -0.16375    -0.17495     -0.1319   -0.043579     0.10542     0.43213     0.11147    0.085637    0.040871    0.075468     0.47398     0.10674     0.19301    0.064144    -0.10544    0.066635   -0.0019323   -0.012686    0.026909    0.032853   -0.011526    -0.14983   -0.097338    0.015295   0.0012197  0.00073051  -0.0025295     0.006219  -0.0059235   0.0073083
 -0.21539   0.0096667    0.010481    0.063948     0.17301    -0.17349   -0.097145    0.039533     0.11574     0.17519     0.13802   -0.053122    -0.24721    -0.20795    0.049886    -0.11004    -0.15661    -0.16464    -0.14333    -0.15761    -0.10207    0.060285     0.26203     0.28259     0.18828     -0.3418    -0.30882    -0.30617    -0.14915    -0.24509   -0.019231    -0.01947   -0.017903    0.016218    0.037843   -0.038128   -0.0099245   0.0075411   -0.012178   -0.039355    0.052132    0.013412   0.0072229    0.022216   -0.013497    0.018134  -0.0014374   -0.0053459  -0.0040232  -0.0041325
 -0.20301  -0.0093563    0.047276    0.087639     0.18453    -0.15769   -0.038924     0.10728     0.16329     0.16923    0.050947    -0.16655     -0.1947   -0.033074    -0.15979    -0.23218    -0.15044    -0.10116   -0.039968   -0.011079     0.10866     0.14887     0.10054   -0.033347    -0.14072   -0.025041     0.19237     0.24991      0.1869     0.42368    -0.20706   -0.034584   -0.062889    -0.13518   -0.016231     0.17222    -0.075512   -0.079966    0.048626       0.229     -0.2639    0.052958   -0.016203     -0.1229    0.049744   -0.066956    0.013771   -0.0014288    0.021736    0.010131
 -0.18849   -0.030377    0.081309    0.099648     0.18907    -0.12324    0.026296     0.16137     0.17848     0.11784   -0.037527    -0.19493   -0.077034      0.1094    -0.23344    -0.17925   -0.039763    0.052782    0.098038     0.12725       0.166    0.069996   -0.093976    -0.16593    -0.13006    0.054962     0.11889    0.090157    0.019289    -0.08913     0.07195    0.031152  -0.0052767    0.078573    0.034191    -0.26416      0.17953     0.13709   -0.055364    -0.36987      0.4257    -0.13614    0.027173     0.19448   -0.073746    0.097519   -0.030277     0.004836     -0.0314    -0.02776
 -0.17165   -0.053069     0.11076     0.10066     0.18912    -0.07966    0.088251      0.1905     0.15659    0.033765    -0.11549    -0.15654    0.050839     0.17088    -0.15847    0.010073     0.13806     0.19279     0.16173     0.14624    0.044611    -0.10194    -0.19011     -0.1069   0.0095375     0.08363   -0.091269    -0.17374    -0.16606    -0.39138    0.098469   -0.028211    0.073375     0.15669   -0.012744   -0.010594      -0.1096    -0.03353   -0.055847     0.24568    -0.36556     0.15687   -0.026174    -0.21896    0.086108    -0.10287     0.06169     0.014732    0.024045    0.042066
 -0.15307   -0.076475     0.13455    0.092759     0.18524   -0.033061     0.13643     0.18761    0.098895   -0.065586      -0.166   -0.082704     0.11331     0.12961  0.00098971     0.20207     0.22258     0.17548    0.046875   -0.016269    -0.15989    -0.16383   -0.029755     0.13419     0.16493   -0.026447    -0.13699   -0.087065  -0.0047274     0.22316   -0.091175   0.0057541   -0.048222    -0.22485   -0.050933     0.39174     -0.10386    -0.16472     0.17783    0.014618      0.1941   -0.073665    0.046433     0.29059    -0.11692     0.16963    -0.10213    -0.052066   -0.047184   -0.055984
 -0.13283    -0.10013     0.15219    0.076831      0.1786    0.011979     0.16665     0.15508    0.019482    -0.15056    -0.17413  0.00025818     0.11873    0.035513     0.13034     0.24632     0.14041   0.0044802    -0.12194    -0.15589    -0.16988   -0.027789     0.13618     0.14308    0.063338    -0.08256   0.0098724    0.087453     0.12855     0.20939   0.0088309     0.06433   -0.021991   -0.048819    0.071325      -0.265      0.22257     0.22525    -0.13131    -0.17322   0.0027554   -0.040658   -0.064561    -0.34126     0.14821    -0.30637     0.11488     0.032879     0.12926    0.086564
  -0.1112    -0.12324      0.1632    0.054778      0.1692    0.052012     0.17699     0.10055   -0.063696    -0.19714    -0.12838    0.073511    0.083067   -0.050345     0.17848     0.13569   -0.048306    -0.19218    -0.19603    -0.14209    0.007791     0.13915     0.12783   -0.032479    -0.14399   -0.016056     0.16035     0.14009    0.024667    -0.10323    0.014746   -0.055533    0.031347     0.23462   0.0031949    -0.26505    -0.089849   -0.073862   -0.068675     0.17209    -0.20171    0.094127    0.040967     0.25496     -0.1312     0.38483   -0.076918      0.04608    -0.21959    -0.13413
-0.088278    -0.14512     0.16742    0.028115     0.15824    0.085347     0.16952    0.034095    -0.13328    -0.19494   -0.047916     0.12126    0.038438   -0.093551     0.13669   -0.033958    -0.19942    -0.24199   -0.095211    0.013727     0.16857     0.14602   -0.025804    -0.15494    -0.14019    0.057904    0.064353   -0.011407    -0.09298    -0.22721   -0.031296   -0.091744    0.014256    0.071224    -0.08056     0.33958     -0.17779     -0.1255     0.17107   -0.064294     0.27442   -0.072272   0.0041434   -0.051437    0.062604    -0.32926    0.013081     -0.10805     0.24788     0.14726
-0.064775    -0.16522     0.16477  -0.0014323     0.14644     0.11037     0.14625   -0.036159    -0.17943    -0.14802    0.051394     0.14234    -0.00997   -0.096183    0.042979    -0.17744    -0.22219    -0.11176     0.10839     0.16795     0.15459   -0.021319    -0.16745   -0.077897     0.08504    0.065052    -0.14748     -0.1709   -0.063932    0.058035    0.039604     0.13951   -0.045397    -0.38039    0.056973     0.15344        0.285     0.19159   -0.064729   -0.088379    -0.15454    0.028586   -0.035499    -0.14703    0.021933     0.22208    0.060636      0.18621    -0.24521    -0.12174
-0.041133    -0.18297     0.15552   -0.032498     0.13457     0.12673      0.1098    -0.10114    -0.19363   -0.066253      0.1351     0.11498   -0.050564   -0.069186   -0.048639    -0.22337    -0.11504      0.1064     0.22929     0.15612   -0.021143    -0.14866   -0.081891     0.10329     0.16648   -0.025208    -0.11447   -0.055774    0.077536     0.24207   0.0059611    0.039329   -0.008665    0.078968    0.024214    -0.38287    -0.098846   -0.086649   -0.087238     0.16815   -0.041047    0.013626      0.0545      0.2407   -0.061587    -0.11271    -0.12457     -0.32282     0.28176     0.11383
-0.017697    -0.19769     0.14004    -0.06295     0.12372     0.13293    0.065791    -0.15266    -0.17513    0.032229     0.17797    0.051678   -0.082166   -0.022978    -0.12026    -0.15236    0.060557     0.24516     0.16367   -0.011223    -0.17726   -0.099765     0.10968     0.14994    0.019931   -0.066057    0.075618     0.13627    0.051904    0.013161    -0.07743    -0.15478    0.066214     0.32586   -0.057331    0.048918     -0.19921   -0.083756     0.13039    -0.09524     0.16753   -0.032184   -0.041336    -0.22169    0.020118   -0.027475     0.13801      0.38878     -0.2886    -0.11551
0.0054445    -0.20879     0.11847   -0.091337     0.11402     0.12943     0.01557    -0.18558    -0.12475     0.12139     0.17014    -0.02421   -0.085617    0.023867    -0.13414   -0.017858     0.18612     0.22549   -0.042981    -0.17578    -0.15347    0.057399     0.17867    0.017982    -0.14044   -0.034832     0.16472     0.16213    0.013858    -0.28404      0.0332   -0.009599    0.024299   -0.083604    0.024127     0.29016      0.29739     0.17926   -0.058467    -0.07087    -0.17789     0.01591  -0.0072856    0.083446    0.070094     0.18859    -0.11348     -0.28417     0.21972    0.084263
 0.028016    -0.21572    0.091965    -0.11594     0.10584     0.11759   -0.035977    -0.19582   -0.050262     0.18529     0.11764   -0.093941   -0.061081    0.067552    -0.10123     0.11608     0.20507    0.046536    -0.23806    -0.17526      0.0564     0.15734  -0.0045141    -0.17597    -0.10838    0.084345   -0.013432    -0.13668   -0.088267   -0.029932     0.09882     0.18476    -0.13873    -0.38024    0.017633    -0.22463     -0.12212    -0.15354   -0.033867      0.1932     0.11021   0.0067229    0.050246     0.10638    -0.15057    -0.30991    0.097822       0.1434    -0.16241    -0.03009
  0.04994    -0.21776    0.061704    -0.13522    0.098692    0.098804   -0.084477    -0.18037     0.03568     0.20464    0.029904    -0.14021  -0.0076968    0.092033   -0.029401     0.18363     0.12095    -0.15957    -0.23994  -0.0020652     0.19504    0.059685    -0.16845    -0.11431     0.06237    0.064717    -0.17228    -0.21489   -0.090837     0.30981   -0.077854    -0.10186    0.055073     0.26479   -0.046519   -0.040109     -0.12137    0.030792    0.073667    -0.16671 -0.00064949   -0.030582   -0.058122    -0.24996     0.15211     0.34921   -0.069808     -0.12051     0.13984   0.0068561
 0.070984    -0.21464    0.028671    -0.14813    0.093353    0.074268    -0.12589    -0.13985     0.12334     0.16904   -0.071315     -0.1377    0.054226    0.079803    0.067335      0.1611   -0.050444    -0.26632   -0.020361     0.19702     0.12582    -0.12523     -0.1217     0.12525     0.17144    -0.09188   -0.043326     0.14124      0.1798   -0.052726   -0.074773   -0.076078     0.16387      0.2019    0.054998     0.18165       0.2585     0.12196   -0.064264    0.040309    -0.11614    0.041769    0.036576     0.34813   -0.071172    -0.34169   0.0046228      0.15416    -0.11548    -0.01454
 0.088532    -0.20756  -0.0051802    -0.15702    0.090109    0.044859    -0.15092   -0.083644     0.17893     0.10409    -0.14461   -0.082364    0.085692    0.038705     0.11077    0.083536    -0.14501    -0.19174     0.18394     0.19863   -0.058545    -0.15197    0.046224     0.16651    0.041898   -0.085115     0.12198     0.24149     0.15704    -0.26433    0.076055     0.13472    -0.12585     -0.2601   0.0030355    -0.10016     -0.16227    -0.17771  -0.0022249    0.079836     0.17105   -0.026106  -0.0075073    -0.33457    -0.08465     0.24666    0.059898     -0.15269    0.055319   0.0034544
  0.10328    -0.19611   -0.038987    -0.16069    0.089919     0.01301     -0.1608   -0.017469     0.20491    0.018995    -0.18181   0.0010039    0.085339   -0.020205     0.11467    -0.02568    -0.16495   0.0064947     0.26084    0.016531    -0.21039   0.0023774     0.19043  -0.0075285    -0.20833    0.066109     0.13903    -0.14775    -0.37232     0.14577    0.095401    -0.11109    -0.22364   -0.052726    -0.11693    -0.06573     -0.07833    0.099622    0.073034    -0.14251    -0.15146    0.016294   -0.020897     0.22857     0.30298   -0.071294    -0.12653      0.19428    0.078892    -0.02401
  0.11528    -0.18057   -0.071487    -0.15906    0.093052   -0.018654    -0.15619    0.048403     0.19913   -0.063403    -0.16991    0.071956    0.060813   -0.060905    0.088909    -0.10045    -0.13326     0.17355     0.15118    -0.18692    -0.12915       0.155    0.080515    -0.15975    -0.10819    0.090435   -0.076159    -0.18419   -0.034726     0.13171    -0.11676   0.0060329     0.24591     0.14985    0.099554    0.081073      0.15554    0.014014   -0.044984    0.071047     0.05669   -0.025625    0.030695    -0.13976    -0.39307   -0.044593     0.18841     -0.30519    -0.24213     0.12512
   0.1246    -0.16103    -0.10182    -0.15133    0.098597   -0.049375     -0.1361     0.11073       0.159    -0.13767    -0.10643     0.12801   0.0066399    -0.08727    0.028034    -0.14752   -0.041364     0.25255    -0.07625    -0.22159    0.074021     0.13675    -0.11182    -0.11757     0.11958   -0.009726    -0.16031    0.036976     0.31438    -0.10639   -0.071315     0.16051     0.18712   -0.027421    0.096414 -0.00019715   -0.0069131   -0.099678   -0.051913     0.10378     0.10086    0.042229  -0.0045191    0.044271     0.25241    0.082064    -0.17143      0.32804     0.31509    -0.19398
  0.13132    -0.13792    -0.12873    -0.13858     0.10707   -0.076037    -0.10252     0.15914    0.092351    -0.18295    -0.01562     0.14308   -0.046134   -0.080537   -0.041262    -0.14369    0.076988     0.17681    -0.25744   -0.063457      0.2022   -0.034852    -0.17603    0.065817     0.19721   -0.076682   -0.035198     0.18614    0.075071   -0.072537     0.11563    -0.10397    -0.35566   -0.016764    -0.17231  -0.0096836     -0.20951     0.14114    0.092873    -0.23778    -0.19506   -0.037005   -0.027052    0.060508  -0.0020869   -0.066847    0.071706     -0.20648    -0.26724     0.16595
  0.13574    -0.11173     -0.1514    -0.12125     0.11738   -0.096946    -0.05726     0.18984   0.0065425    -0.19206    0.082805     0.10263   -0.085293   -0.041149    -0.10302   -0.079807     0.18396   -0.028748    -0.24211     0.18466     0.11093    -0.18694   0.0021742     0.18997    -0.05469     -0.0344     0.20784   -0.011252    -0.36344    0.098431     0.06732    -0.19313   -0.035961    0.034405   0.0060772   0.0088689      0.28971   -0.077898    -0.05745     0.24171     0.14078 8.1812e-005    0.033229    -0.11583    -0.22881    0.025996    0.032131      0.10121     0.23794    -0.19311
  0.13756   -0.083653    -0.16908   -0.099202     0.12907    -0.11175  -0.0070174     0.19637    -0.07541    -0.15679     0.15582     0.03014   -0.091701   0.0098466    -0.12409    0.016482     0.19421    -0.19619   -0.051514     0.23666   -0.075131    -0.10776     0.14621    0.045791    -0.15611    0.046433    0.053968    -0.10439     0.03683   -0.017992    -0.14531      0.2242     0.35438   -0.086341     0.13349   -0.056132    -0.065711    -0.10545    0.033651   -0.056622    0.028264    0.032545   -0.021741    0.069166     0.34143    0.018524    -0.10054    -0.060003    -0.27059      0.3384
  0.13681   -0.054528     -0.1811   -0.072879     0.14023    -0.11929    0.043735     0.17721    -0.14265   -0.084018      0.1851   -0.046637   -0.065204    0.046549     -0.1033     0.11025     0.11064    -0.23657     0.17393    0.083421    -0.18422    0.084458     0.10874    -0.14152   -0.068416    0.056669    -0.14082   -0.051442     0.19873   -0.033446   -0.018499     0.10542   -0.039564    0.025007   -0.048833    0.047143     -0.24934     0.22383    0.026298     -0.2005    -0.18362    -0.04362   0.0083443    0.028578    -0.29367   -0.063761     0.14082   -0.0088437     0.23185    -0.39836
  0.13407   -0.024911    -0.18692   -0.044171     0.15121    -0.11827    0.090926     0.13564    -0.18419   0.0049435     0.16206    -0.10506   -0.021331    0.065954   -0.040535     0.16887   -0.044268    -0.12932     0.26047    -0.14425   -0.096511     0.17776   -0.058691    -0.14049     0.10073  -0.0074585    -0.13348    0.034704    0.095585    0.031297     0.14069    -0.17777    -0.37961     0.13747   -0.057563    0.085757      0.17914   -0.027285     -0.2091     0.27402     0.20401    0.019569   0.0070364   -0.044171    0.096606    0.080394    -0.12186      0.10335   -0.088067     0.30694
  0.12966   0.0044298    -0.18633   -0.014664     0.16209    -0.10881      0.1311    0.077934    -0.19544    0.095643    0.092387    -0.13477    0.033511    0.070227    0.041955     0.15495    -0.20293    0.060678     0.15388    -0.24849    0.098515    0.067278    -0.16088    0.054236     0.14519   -0.065787    0.093136     0.12182     -0.1835   -0.028518   -0.039554   -0.096525     0.20705      -0.122   -0.017666    -0.16681      0.20604    -0.31152     0.31309     -0.1399    -0.10616    0.017845   -0.030498  -0.0076444     0.14242   -0.095408    0.039054     -0.20402   -0.074973    -0.28221
  0.12414    0.032955    -0.17968    0.014662     0.17267   -0.090783     0.16155    0.010263    -0.17497     0.16363  -0.0012682    -0.12327     0.06792    0.058906     0.11102    0.073701    -0.24675     0.19513   -0.050677    -0.12073     0.17235    -0.10995   -0.057463     0.15426   -0.018008   -0.027856     0.15202  -0.0016457    -0.13083    0.017743   -0.074562     0.10477     0.18882    -0.08767    0.029085    0.017947     -0.26304     0.29242   -0.064761   -0.023156   -0.040242   -0.018582    0.029817    0.023723    -0.27483     0.11038   0.0046672       0.2801      0.1733     0.37624
  0.11799    0.060126    -0.16705    0.041725     0.18204   -0.064743     0.17767   -0.060151    -0.12339     0.19256   -0.095749   -0.065567    0.082758     0.02643     0.15937   -0.065088    -0.14563     0.20106    -0.21033     0.11697    0.066271    -0.16944     0.12146     0.04627     -0.1517    0.058195    0.010489    -0.11889    0.088257    0.031262    0.043744    0.098038    -0.14997     0.13235     0.10799     0.14827     -0.10356     0.10473    -0.29917     0.11854     0.16509     0.01699   0.0049528   0.0022471     0.27012   -0.082896    0.012222     -0.26766    -0.17147    -0.37331
  0.11153    0.085327     -0.1488    0.065521     0.18988    -0.03167     0.17731    -0.12327   -0.049328     0.17684    -0.15971   0.0022735    0.078475   -0.020076     0.14193    -0.18228    0.050079    0.076624    -0.19772     0.23733    -0.10739   -0.040444     0.15245    -0.11952   -0.088766    0.062322    -0.15292   -0.081052     0.20344   -0.030101    0.029522    0.012752     -0.1774    0.074253   -0.043112   -0.057985      0.27336    -0.39562      0.2267    -0.18454    -0.19415   -0.032617   -0.018651    0.013053    -0.14607    0.048465    0.081411       0.1653     0.12102     0.20252
  0.10489     0.10795    -0.12563     0.08486     0.19548   0.0069417     0.16014    -0.17237    0.034605     0.11956    -0.17927    0.066661    0.063072   -0.084277    0.052506    -0.21955     0.23062    -0.10111   -0.024753     0.12662    -0.17091     0.15225   -0.008336    -0.13824     0.14405   -0.042478   -0.079373     0.15748   -0.083001   -0.039297   -0.042715    -0.20978     0.22286    -0.17416    -0.21639    -0.11836    -0.048444     0.34085     0.16739      0.1973     0.11599    0.010246    0.017934    -0.10583   -0.035317    -0.06107    -0.33951    -0.047136   -0.098801   -0.058971
 0.098617     0.12779   -0.098311    0.098274     0.19843    0.049043     0.12585    -0.19836     0.11238    0.033864    -0.14496     0.11626    0.022302     -0.1397   -0.085543     -0.1256     0.25359    -0.18555     0.13396   -0.088615   -0.046848     0.14927    -0.15619    0.029692     0.13666   -0.065481    0.089256    0.086895    -0.15152    0.060931    0.041939   -0.026175    0.042057     -0.0158      0.2302    0.080274      -0.1208   -0.091635    -0.24528   -0.063191    0.020326    0.069896   -0.042179     0.18336     0.15147     0.11006     0.53569   -0.0077101     0.10261    0.049554
 0.092916     0.14472   -0.067343     0.10388     0.19871    0.092351    0.075458    -0.19389     0.16521   -0.057726   -0.077284     0.13551   -0.034903    -0.12884    -0.20799      0.0665    0.090932    -0.12236     0.16644    -0.20191     0.13228   -0.025145    -0.10479     0.17884   -0.063548  -0.0060823     0.13939   -0.096885   -0.024404  -0.0044659   -0.016643     0.30203    -0.16083     0.16504     0.13711    0.080308    0.0092447    -0.12953   -0.047093      -0.136    -0.11669    -0.12921    0.052984    -0.15989     -0.1609    -0.12602    -0.48898     0.017838   -0.082021   -0.054699
  0.08791     0.15856   -0.033298     0.10085     0.19516     0.13192    0.014069    -0.15824     0.18061    -0.12547   0.0031266     0.12568    -0.11198   -0.036503    -0.22866     0.21904     -0.1206    0.011717     0.05743    -0.10652     0.15103    -0.16009    0.055645     0.11034     -0.1713    0.064791   -0.018139    -0.17945     0.21454    -0.04585   -0.082461    0.023775   0.0072714  -0.0020407    -0.44589    -0.09436      0.14039     0.17794     0.23484       0.209     0.10243    0.064548   0.0065032    0.081902     0.11415    0.078405     0.28568    -0.022862    0.036078    0.014364
 0.083899     0.16919   0.0026865    0.087486     0.18841     0.16285   -0.048927    -0.10041     0.16101    -0.15939    0.077117    0.086295    -0.18133     0.11469    -0.11566     0.23096    -0.22069     0.10788   -0.071771    0.079605   0.0072093    -0.10028     0.14404    -0.11976   -0.055565    0.056298    -0.17545    0.077628     0.06398    0.014673     0.15753    -0.50545       0.127    -0.20713     0.31073  -0.0085645     -0.12299   -0.096131    -0.16173     -0.1444   -0.032077     0.05384   -0.084264   -0.023325   -0.070582   -0.028766    -0.12391     0.012259  -0.0076189   0.0048643
 0.081065     0.17735    0.039352     0.06245     0.17711     0.17774    -0.10361   -0.032599     0.11329    -0.15678     0.14327  -0.0027931    -0.18048     0.25183     0.10375    0.077341    -0.15549      0.1073    -0.11904     0.16939    -0.14843    0.091724    0.052358    -0.19522      0.1927   -0.071707   -0.081925     0.28893    -0.31846    0.031388   -0.065163     0.42119    -0.11247     0.18786     0.11896    0.027707     0.033002    0.084661     0.18663     0.11672   0.0054782   -0.082775     0.09727    0.010109    0.053735    0.020526    0.071979 -7.9645e-005    0.010642    0.010208
 0.078442     0.18356    0.076433    0.026661     0.16145     0.17057    -0.13803    0.024993    0.064036    -0.13215     0.18575    -0.13158   -0.044781     0.24222     0.28056    -0.14057     0.03168    0.021584   -0.040275    0.050782    -0.11535     0.15844    -0.12861    0.053118     0.10852    -0.05286     0.27498    -0.21402    0.083722   -0.011469    -0.10975  -0.0045967    0.080913   -0.052351     -0.4337    0.028935    0.0025782    -0.16479    -0.37046    -0.15313   -0.010775    0.093437    -0.15425  -0.0099482   -0.058973   -0.029447   -0.062979   -0.0028751   -0.011132   -0.018613
 0.077069      0.1871     0.11205   -0.017661     0.14372     0.14672    -0.14826    0.063097    0.019904    -0.09789     0.19506    -0.23143     0.13474    0.075103     0.27345    -0.22539     0.15688   -0.058472    0.062122     -0.1057    0.046074     0.02418    -0.12467     0.17647     -0.1472    0.040259    0.057022    -0.17179     0.19103   -0.024565     0.13305     -0.1832    -0.05035   -0.023859     0.33886   -0.037798    -0.010155     0.14255     0.29671     0.11029   -0.024244    -0.17918     0.32908   -0.017715    0.073093    0.029272    0.051652    0.0054834 -0.00027928    0.006238
 0.076724     0.18902     0.14183   -0.062702     0.12795     0.11822    -0.14913    0.098013   -0.033451   -0.029179     0.12893    -0.23575     0.29878    -0.21004    0.043337    -0.12799     0.11878    -0.05419    0.075157    -0.14432     0.17635    -0.19135     0.12589  -0.0093593    -0.14661    0.065624     -0.2933     0.23676    -0.13562    0.024992   -0.022174     0.11295   -0.028583    0.028165  -0.0089529   0.0021572     0.012424 -0.00027629    0.019245  -0.0059006      0.0783     0.26717     -0.4787    0.040481   -0.078483   -0.016877   -0.042194    -0.011353   0.0092349    0.003053
 0.075825     0.19083     0.16388    -0.09651     0.11648     0.10374    -0.16213     0.14861     -0.1131    0.073414   -0.011878    -0.09964     0.27593    -0.35776    -0.22184    0.083447   -0.048408     0.02902   -0.036362    0.035971    0.032125    -0.10707     0.17432     -0.2145     0.15988   -0.047692    0.009584    0.044206   -0.060975  -0.0010966     -0.0487   -0.027475    0.089074   -0.032153    -0.20423    0.011825   -0.0043242    -0.10285    -0.22786   -0.055787   -0.087262    -0.26994     0.47273   -0.040145    0.070803   0.0091817    0.037251     0.020015  -0.0090706  -0.0012297
  0.07371     0.19308     0.18449    -0.12772     0.10485    0.088726    -0.17544     0.20442    -0.20152     0.18199    -0.16752     0.10411    0.033799    -0.17932    -0.22283     0.14782    -0.11517    0.066208   -0.098889     0.16943    -0.17242     0.17858     -0.1061   -0.017965     0.16975   -0.072371     0.32989    -0.23827     0.13132   -0.010034    0.036025  -0.0022312   -0.089694    0.033591      0.2205  -0.0025764    -0.004527     0.10151     0.22228    0.055677    0.054728     0.17811    -0.30241    0.025674   -0.045942  -0.0019661    -0.02354    -0.016662    0.003898  0.00064583
 0.071823     0.19568     0.21423    -0.19588    0.079699  0.00072321    -0.11348     0.18061    -0.20409     0.21834    -0.24434     0.24231    -0.23072     0.15907   0.0057059   0.0076332   0.0011506   -0.021389   0.0075073     0.01318   -0.072593     0.16369    -0.22303     0.34324    -0.34047     0.11501    -0.33253      0.1953   -0.078007   0.0044477  -0.0064627    0.012113    0.048879   -0.016624    -0.11823  -0.0024184    0.0055929   -0.050189    -0.11073   -0.025247   -0.020016    -0.07096     0.10765  -0.0082505    0.017851  -0.0035098   0.0065074    0.0052316  -0.0030158  -0.0014308
 0.072297     0.19648     0.25583    -0.31916    0.032392    -0.19762    0.078318   0.0088026   -0.048441    0.093993    -0.14886     0.19618     -0.2672     0.27684     0.15953    -0.10205     0.14765    -0.11692     0.15333    -0.20974     0.23852    -0.31294     0.27111     -0.2854     0.20465   -0.060003     0.14008   -0.076278    0.027746  -0.0018315  0.00030406   -0.012977   -0.010758   0.0034056    0.027192  0.00074584  -0.00081551     0.01293    0.028838   0.0053606    0.002764    0.012824   -0.010297   0.0020011  -0.0035121   0.0014643  0.00057799   0.00046296   0.0033405   0.0011374
 0.072614     0.18897     0.28837    -0.45497   -0.027337    -0.44185     0.34545    -0.26782     0.24274    -0.19474       0.177    -0.14105     0.12932    -0.11306    -0.06424     0.07097    -0.10018    0.075329   -0.085197     0.11572    -0.12031     0.14428     -0.1079    0.092792    -0.04929    0.012826   -0.018899    0.010619  -0.0047913   0.0004305 -0.00069123   0.0054356 -0.00031937  0.00078146 -0.00077656  0.00026662  -0.00073825 -0.00083773  -0.0030294 -0.00057875  0.00059994   0.0016147  -0.0064176 -0.00035792 -0.00034238 -0.00016517 -0.00092783  -0.00087116  -0.0011449 -0.00058981
];

return;
end
