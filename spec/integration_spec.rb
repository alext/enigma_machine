require 'spec_helper'

describe "Integration tests" do

  specify "An enigma machine set to I-II-III, MCK encodes E to Q" do
    pending
    EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"]).process("E").should == "Q"
  end

  specify "Encoding the cyphertext of a message with the same settings returns the original message" do
    pending
    e = EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"])
    e.process("E").should == "Q"
    e = EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"])
    e.process("Q").should == "E"
  end

  specify "Encoding the same letter twice returns a different answer" do
    pending
    e = EnigmaMachine.new([1, "M"], [2, "C"], [3, "K"])
    e.process("E").should == "Q"
    e.process("E").should_not == "Q"
  end

  context "with no rotor offset" do
    specify "An enigma machine set to I-II-III, MCK encodes E to Q" do
      EnigmaMachine.new([1, "A"], [2, "A"], [3, "A"]).process("E").should == "B"
    end

    specify "Encoding the cyphertext of a message with the same settings returns the original message" do
      e = EnigmaMachine.new([1, "A"], [2, "A"], [3, "A"])
      e.process("E").should == "B"
      e = EnigmaMachine.new([1, "A"], [2, "A"], [3, "A"])
      e.process("B").should == "E"
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

        result.should == 'FEIND LIQEI NFANT ERIEK OLONN EBEOB AQTET XANFA NGSUE DAUSG ANGBA ERWAL DEXEN DEDRE IKMOS TWAER TSNEU STADT'
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
        result.should == 'AUFKL XABTE ILUNG XVONX KURTI NOWAX KURTI NOWAX NORDW ESTLX SEBEZ XSEBE ZXUAF FLIEG ERSTR ASZER IQTUN GXDUB ROWKI XDUBR OWKIX OPOTS CHKAX OPOTS CHKAX UMXEI NSAQT DREIN ULLXU HRANG ETRET ENXAN GRIFF XINFX RGTX-'

        e.set_rotors('L', 'S', 'D')
        result = e.translate('SFBWD NJUSE GQOBH KRTAR EEZMW KPPRB XOHDR OEQGB BGTQV PGVKB VVGBI MHUSZ YDAJQ IROAX SSSNR EHYGG RPISE ZBOVM QIEMM ZCYSG QDGRE RVBIL EKXYQ IRGIR QNRDN VRXCY YTNJR')
        result.should == 'DREIG EHTLA NGSAM ABERS IQERV ORWAE RTSXE INSSI EBENN ULLSE QSXUH RXROE MXEIN SXINF RGTXD REIXA UFFLI EGERS TRASZ EMITA NFANG XEINS SEQSX KMXKM XOSTW XKAME NECXK'

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
        result.should == 'STEUE REJTA NAFJO RDJAN STAND ORTQU AAACC CVIER NEUNN EUNZW OFAHR TZWON ULSMX XSCHA RNHOR STHCO'

        # German: Steuere Tanafjord an. Standort Quadrat AC4992, fahrt 20sm. Scharnhorst. [hco - padding?]
        # English: Heading for Tanafjord. Position is square AC4992, speed 20 knots. Scharnhorst.
      end
    end

  end
end
