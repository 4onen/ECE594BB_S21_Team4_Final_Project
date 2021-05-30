zero_seq = '01000000100000000010'
one_seq = '01010100010101000101'
translation = {'0':zero_seq,'1':one_seq}

if __name__=="__main__":
    import sys
    assert(len(sys.argv)==3)
    values=list()
    with open(sys.argv[1],'r') as infile:
        for line in infile:
            for c in line:
                if c in translation.keys():
                    values.append(translation[c])
    
    transposed = (list(map(lambda v: ''.join(v),zip(*values))))
    
    with open(sys.argv[2],'w') as outfile:
        for line in transposed:
            outfile.write(line)
            outfile.write('\n')