from typing import Dict, List
from read_vcd import Signal, VCD, read_vcd
import numpy as np

def bin_array(num,width:int):
    return np.array(list(np.binary_repr(num,width=width))).astype(bool)

def signal_transitions(sig:Signal,start_time=0,end_time=None):
    width:int = sig.width
    count:List[int] = np.zeros((sig.width,),dtype=np.uint32)
    
    lastval:str = bin_array(sig[0],width)[-width:]

    for tstep,val in sorted(sig._dat.items()):
        if end_time is not None and tstep>end_time:
            break
        valbin = bin_array(val,width)[-width:]
        if tstep>=start_time:
            diffs = lastval^valbin
            count += diffs
        lastval = valbin
    
    return count
            


class Activities():
    
    __slots__ = ['_sigs','translations']

    _sigs: Dict[str,List[int]]
    translations: Dict[str,str]

    def __init__(self,signals:VCD):
        self.translations = signals.translations
        start_time = 20000 if 'net.rstb' in signals.translations.keys() else 22
        end_time = None if 'net.rstb' in signals.translations.keys() else 104
        self._sigs = {k:signal_transitions(sig,start_time) for k,sig in signals._sigs.items()}
    
    def __str__(self) -> str:
        return "Activities: {}".format(self.translations)
    
    def __getitem__(self, key):
        r = self._sigs.get(key,None)
        if r is None:
            r = self._sigs[self.translations[key]]
        return r

if __name__=="__main__":
    from sys import argv
    if len(argv)<2:
        print("Usage: {} VCD1 [VCD2] [VCD3] [...]".format(argv[0]))
    else:
        for filename in argv[1:]:
            activities = Activities(read_vcd(filename))
            for name in activities.translations.keys():
                print("{} {}".format(name,activities[name]))
