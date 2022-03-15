# %%
import json
import tablib
import pandas as pd
import re

do_osd_op_post = []
do_osd_op_pre = []
do_osd_op_pre_create = []
do_osd_op_pre_delete = []
do_osd_op_pre_omaprmkeys = []
do_osd_op_pre_omapsetheader = []
do_osd_op_pre_omapsetvals = []
do_osd_op_pre_write = []
do_osd_op_pre_writefull = []
ms_fast_dispatch = []
opwq_process_finish = []
opwq_process_start = []
prepare_tx_enter = []
prepare_tx_exit = []
trace = open('./result/osd_trace.json')

index_list1=["cpu_id","oid","snap","op","opname","flags","result"]
index_list2=["cpu_id","oid","snap","op","opname","flags"]
index_list3=["cpu_id","oid","snap"]
index_list4=["cpu_id","oid","snap","osize","oseq","offset","length","truncate_size","truncate_seq"]
index_list5=["cpu_id","oid","snap","osize","offset","length"]
index_list6=["cpu_id","type","num","tid","inc"]

data = trace.readlines()
list = []
dict = set()

for line in data :
    line = line[56:]
    list.append(line.split(':'))
    
for info in list:
    list_str = re.split(',', info[1].replace('{','').replace('}','').replace('\n',''))
    list_data = []
    for str in list_str:
        list_data.append(re.sub(r'^.*?=', '', str))
    if info[0] == "do_osd_op_post":
        do_osd_op_post.append( list_data)
    elif info[0] == "do_osd_op_pre":
        do_osd_op_pre.append( list_data)
    elif info[0] == "do_osd_op_pre_create":
        do_osd_op_pre_create.append( list_data)
    elif info[0] == "do_osd_op_pre_delete":
        do_osd_op_pre_delete.append( list_data)
    elif info[0] == "do_osd_op_pre_omaprmkeys":
        do_osd_op_pre_omaprmkeys.append( list_data)
    elif info[0] == "do_osd_op_pre_omapsetheader":
        do_osd_op_pre_omapsetheader.append( list_data)
    elif info[0] == "do_osd_op_pre_omapsetvals":
        do_osd_op_pre_omapsetvals.append( list_data)
    elif info[0] == "do_osd_op_pre_write":
        do_osd_op_pre_write.append(list_data)
    elif info[0] == "do_osd_op_pre_writefull":
        do_osd_op_pre_writefull.append( list_data)
    elif info[0] == "ms_fast_dispatch":
        ms_fast_dispatch.append( list_data)
    elif info[0] == "opwq_process_finish":
        opwq_process_finish.append( list_data)
    elif info[0] == "opwq_process_start":
        opwq_process_start.append( list_data)
    elif info[0] == "prepare_tx_enter":
        prepare_tx_enter.append( list_data)
    elif info[0] == "prepare_tx_exit":
        prepare_tx_exit.append( list_data)

df = pd.DataFrame(do_osd_op_post,columns=index_list1)
df.to_csv("./result/trace/do_osd_op_post.csv",index=False)

df = pd.DataFrame(do_osd_op_pre,columns=index_list2)
df.to_csv("./result/trace/do_osd_op_pre.csv",index=False)

df = pd.DataFrame(do_osd_op_pre_create,columns=index_list3)
df.to_csv("./result/trace/do_osd_op_pre_create.csv",index=False)

df = pd.DataFrame(do_osd_op_pre_delete,columns=index_list3)
df.to_csv("./result/trace/do_osd_op_pre_delete.csv",index=False)

df = pd.DataFrame(do_osd_op_pre_omaprmkeys,columns=index_list3)
df.to_csv("./result/trace/do_osd_op_pre_omaprmkeys.csv",index=False)

df = pd.DataFrame(do_osd_op_pre_omapsetheader,columns=index_list3)
df.to_csv("./result/trace/do_osd_op_pre_omapsetheader.csv",index=False)

df = pd.DataFrame(do_osd_op_pre_omapsetvals,columns=index_list3)
df.to_csv("./result/trace/do_osd_op_pre_omapsetvals.csv",index=False)

df = pd.DataFrame(do_osd_op_pre_write,columns=index_list4)
df.to_csv("./result/trace/do_osd_op_pre_write.csv",index=False)

df = pd.DataFrame(do_osd_op_pre_writefull,columns=index_list5)
df.to_csv("./result/trace/do_osd_op_pre_writefull.csv",index=False)

df = pd.DataFrame(ms_fast_dispatch,columns=index_list6)
df.to_csv("./result/trace/ms_fast_dispatch.csv",index=False)

df = pd.DataFrame(opwq_process_finish,columns=index_list6)
df.to_csv("./result/trace/opwq_process_finish.csv",index=False)

df = pd.DataFrame(opwq_process_start,columns=index_list6)
df.to_csv("./result/trace/opwq_process_start.csv",index=False)

df = pd.DataFrame(prepare_tx_enter,columns=index_list6)
df.to_csv("./result/trace/prepare_tx_enter.csv",index=False)

df = pd.DataFrame(prepare_tx_exit,columns=index_list6)
df.to_csv("./result/trace/prepare_tx_exit.csv",index=False)


