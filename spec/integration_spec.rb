# encoding: UTF-8

RSpec.describe "Integration tests" do

  describe "basic sample tests" do
    # taken from http://wiki.franklinheath.co.uk/index.php/Enigma/Paper_Enigma

    it "should translate a message that only needs the right rotor to advance" do
      e = EnigmaMachine.new(
        :reflector => :B,
        :rotors => [[:i, 1], [:ii, 1], [:iii, 1]]
      )
      e.set_rotors('A', 'B', 'C')

      expect(e.translate('AEFAE JXXBN XYJTY')).to eq('CONGR ATULA TIONS')
    end

    it "should translate a message with rotor turnover" do
      e = EnigmaMachine.new(
        :reflector => :B,
        :rotors => [[:i, 1], [:ii, 1], [:iii, 1]]
      )
      e.set_rotors('A', 'B', 'R')

      expect(e.translate('MABEK GZXSG')).to eq('TURNM IDDLE')
    end

    it "should translate a message with double stepping" do
      e = EnigmaMachine.new(
        :reflector => :B,
        :rotors => [[:i, 1], [:ii, 1], [:iii, 1]]
      )
      e.set_rotors('A', 'D', 'S')

      expect(e.translate('RZFOG FYHPL')).to eq('TURNS THREE')
    end

    it "should translate a message with ring settings" do
      e = EnigmaMachine.new(
        :reflector => :B,
        :rotors => [[:i, 10], [:ii, 14], [:iii, 21]]
      )
      e.set_rotors('X', 'Y', 'Z')

      expect(e.translate('QKTPE BZIUK')).to eq('GOODR ESULT')
    end

    it "should translate a message with a plugboard as well" do
      e = EnigmaMachine.new(
        :reflector => :B,
        :rotors => [[:i, 10], [:ii, 14], [:iii, 21]],
        :plug_pairs => %w(AP BR CM FZ GJ IL NT OV QS WX)
      )
      e.set_rotors('V', 'Q', 'Q')

      expect(e.translate('HABHV HLYDF NADZY')).to eq('THATS ITWEL LDONE')
    end
  end

  describe "real world sample messages" do
    describe "Enigma I/M3" do
      # Examples taken from http://wiki.franklinheath.co.uk/index.php/Enigma/Sample_Messages
      specify "Enigma Instruction Manual 1930" do
        e = EnigmaMachine.new(
          :reflector => :A,
          :rotors => [[:ii, 24], [:i, 13], [:iii, 22]],
          :plug_pairs => %w(AM FI NV PS TU WZ)
        )

        e.set_rotors('A', 'B', 'L')
        result = e.translate('GCDSE AHUGW TQGRK VLFGX UCALX VYMIG MMNMF DXTGN VHVRM MEVOU YFZSL RHDRR XFJWC FHUHM UNZEF RDISI KBGPM YVXUZ')

        expect(result).to eq('FEIND LIQEI NFANT ERIEK OLONN EBEOB AQTET XANFA NGSUE DAUSG ANGBA ERWAL DEXEN DEDRE IKMOS TWAER TSNEU STADT')
        # German: Feindliche Infanterie Kolonne beobachtet. Anfang Südausgang Bärwalde. Ende 3km ostwärts Neustadt.
        # English: Enemy infantry column was observed. Beginning [at] southern exit [of] Baerwalde. Ending 3km east of Neustadt.
      end

      specify "Operation Barbarossa, 1941" do
        e = EnigmaMachine.new(
          :reflector => :B,
          :rotors => [[:ii, 2], [:iv, 21], [:v, 12]],
          :plug_pairs => %w(AV BS CG DL FU HZ IN KM OW RX)
        )

        e.set_rotors('B', 'L', 'A')
        result = e.translate('EDPUD NRGYS ZRCXN UYTPO MRMBO FKTBZ REZKM LXLVE FGUEY SIOZV EQMIK UBPMM YLKLT TDEIS MDICA GYKUA CTCDO MOHWX MUUIA UBSTS LRNBZ SZWNR FXWFY SSXJZ VIJHI DISHP RKLKA YUPAD TXQSP INQMA TLPIF SVKDA SCTAC DPBOP VHJK-')
        expect(result).to eq('AUFKL XABTE ILUNG XVONX KURTI NOWAX KURTI NOWAX NORDW ESTLX SEBEZ XSEBE ZXUAF FLIEG ERSTR ASZER IQTUN GXDUB ROWKI XDUBR OWKIX OPOTS CHKAX OPOTS CHKAX UMXEI NSAQT DREIN ULLXU HRANG ETRET ENXAN GRIFF XINFX RGTX-')

        e.set_rotors('L', 'S', 'D')
        result = e.translate('SFBWD NJUSE GQOBH KRTAR EEZMW KPPRB XOHDR OEQGB BGTQV PGVKB VVGBI MHUSZ YDAJQ IROAX SSSNR EHYGG RPISE ZBOVM QIEMM ZCYSG QDGRE RVBIL EKXYQ IRGIR QNRDN VRXCY YTNJR')
        expect(result).to eq('DREIG EHTLA NGSAM ABERS IQERV ORWAE RTSXE INSSI EBENN ULLSE QSXUH RXROE MXEIN SXINF RGTXD REIXA UFFLI EGERS TRASZ EMITA NFANG XEINS SEQSX KMXKM XOSTW XKAME NECXK')

        # German: Aufklärung abteilung von Kurtinowa nordwestlich Sebez [auf] Fliegerstraße in Richtung Dubrowki, Opotschka. Um 18:30 Uhr angetreten angriff. Infanterie Regiment 3 geht langsam aber sicher vorwärts. 17:06 Uhr röm eins InfanterieRegiment 3 auf Fliegerstraße mit Anfang 16km ostwärts Kamenec.
        # English: Reconnaissance division from Kurtinowa north-west of Sebezh on the flight corridor towards Dubrowki, Opochka. Attack begun at 18:30 hours. Infantry Regiment 3 goes slowly but surely forwards. 17:06 hours [Roman numeral I?] Infantry Regiment 3 on the flight corridor starting 16 km east of Kamenec.
      end

      specify "Scharnhorst (Konteradmiral Erich Bey), 1943" do
        e = EnigmaMachine.new(
          :reflector => :B,
          :rotors => [[:iii, 1], [:vi, 8], [:viii, 13]],
          :plug_pairs => %w(AN EZ HK IJ LR MQ OT PV SW UX)
        )

        e.set_rotors('U', 'Z', 'V')
        result = e.translate('YKAE NZAP MSCH ZBFO CUVM RMDP YCOF HADZ IZME FXTH FLOL PZLF GGBO TGOX GRET DWTJ IQHL MXVJ WKZU ASTR')
        expect(result).to eq('STEU EREJ TANA FJOR DJAN STAN DORT QUAA ACCC VIER NEUN NEUN ZWOF AHRT ZWON ULSM XXSC HARN HORS THCO')

        # German: Steuere Tanafjord an. Standort Quadrat AC4992, fahrt 20sm. Scharnhorst. [hco - padding?]
        # English: Heading for Tanafjord. Position is square AC4992, speed 20 knots. Scharnhorst.
      end
    end

    describe "Enigma M4" do
      specify "U-264 (Kapitänleutnant Hartwig Looks), 1942" do
        e = EnigmaMachine.new(
          :reflector => :Bthin,
          :rotors => [[:beta, 1], [:ii, 1], [:iv, 1], [:i, 22]],
          :plug_pairs => %w(AT BL DF GJ HM NW OP QY RZ VX)
        )

        e.set_rotors('V', 'J', 'N', 'A')
        result = e.translate('NCZW VUSX PNYM INHZ XMQX SFWX WLKJ AHSH NMCO CCAK UQPM KCSM HKSE INJU SBLK IOSX CKUB HMLL XCSJ USRR DVKO HULX WCCB GVLI YXEO AHXR HKKF VDRE WEZL XOBA FGYU JQUK GRTV UKAM EURB VEKS UHHV OYHA BCJW MAKL FKLM YFVN RIZR VVRT KOFD ANJM OLBG FFLE OPRG TFLV RHOW OPBE KVWM UQFM PWPA RMFH AGKX IIBG')
        expect(result).to eq('VONV ONJL OOKS JHFF TTTE INSE INSD REIZ WOYY QNNS NEUN INHA LTXX BEIA NGRI FFUN TERW ASSE RGED RUEC KTYW ABOS XLET ZTER GEGN ERST ANDN ULAC HTDR EINU LUHR MARQ UANT ONJO TANE UNAC HTSE YHSD REIY ZWOZ WONU LGRA DYAC HTSM YSTO SSEN ACHX EKNS VIER MBFA ELLT YNNN NNNO OOVI ERYS ICHT EINS NULL')

        # German: Von Von 'Looks' F T 1132/19 Inhalt: Bei Angriff unter Wasser gedrückt, Wasserbomben. Letzter Gegnerstandort 08:30 Uhr Marine Quadrat AJ9863, 220 Grad, 8sm, stosse nach. 14mb fällt, NNO 4, Sicht 10.
        # English: From Looks, radio-telegram 1132/19 contents: Forced to submerge under attack, depth charges. Last enemy location 08:30 hours, sea square AJ9863, following 220 degrees, 8 knots. [Pressure] 14 millibars falling, [wind] north-north-east 4, visibility 10.
      end
    end
  end
end
