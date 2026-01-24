# jessdkant.bsky.social

import pandas as pd
from pathlib import Path
import tkinter as tk
from tkinter import filedialog

root = tk.Tk()
root.withdraw()

pathy = filedialog.askopenfilename()
df = pd.read_csv(
    pathy,
    header=0,
    skipinitialspace=True,
    sep=",")

df['hour']=df['start'].str[:2]
df['minute']=df['start'].str[4:5]

df_new=df[['hour','minute','start','end','text']]

print(df_new.head())

outJSON=Path(pathy).stem+'.json'
df_json=df_new.to_json(outJSON,orient='records', indent=4)

# df_joined=df_new.to_json().join(['hour','minute'])
#df_joined.to_json("temp.json",orient='records', indent=4)

# df_new.groupby(['hour'])
