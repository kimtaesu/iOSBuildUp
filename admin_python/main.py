import datetime
import glob, os
import json
from google.cloud import firestore
import hashlib

from google.cloud.firestore_v1 import DocumentSnapshot

build_up_collection_name = 'build_up'

def update_subjects(data):
    db = firestore.Client()

    subject = data['subject']
    title = data['title']
    subtitle = data['subtitle']
    color = data['color']
    thumbnail = data['thumbnail']

    doc_ref = db.collection("subjects").document(subject)

    doc_ref.set({
        'color':  color,
        'subject': subject,
        'title': title,
        'subtitle': "",
        'thumbnail': thumbnail
    })

def update_question(subject, data):
    db = firestore.Client()

    choices = data['choices']
    question = data['question']
    tags = data['tags']

    hash_key = hashlib.sha256()
    hash_key.update(data['question']['text'].encode('utf-8'))
    hash_key.update(''.join(data['tags']).encode('utf-8'))
    hash_key.update(''.join([c['answer'] for c in data['choices']]).encode('utf-8'))
    docId = hash_key.hexdigest()

    doc_ref = db.collection(build_up_collection_name).document(docId)
    doc_ref.set({
        'subject': subject,
        'docId': docId,
        'question': question,
        'choices': choices,
        'tags': tags
    })

def removed_questions_answers(data):
    db = firestore.Client()
    hash_key = hashlib.sha256()
    hash_key.update(data['question']['text'].encode('utf-8'))
    hash_key.update(''.join(data['tags']).encode('utf-8'))
    hash_key.update(''.join([c['answer'] for c in data['choices']]).encode('utf-8'))
    docId = hash_key.hexdigest()

    db.collection(build_up_collection_name).document(docId).delete()

    usersRef = db.collection("users").get()
    for ref in usersRef:
        ref.reference.collection("answers").document(docId).delete()


if __name__ == '__main__':
    #
    for root, dirs, files in os.walk("Subject"):
        for file in files:
            if file.endswith(".json"):
                file_name = root + "/" + file
                print("open file name: ", file_name)
                with open(file_name, encoding='utf-8', errors='ignore') as json_data:
                    data = json.load(json_data, strict=False)
                    print(data)
                    update_subjects(data)

    for root, dirs, files in os.walk("Staging"):
        for file in files:
            if file.endswith(".json"):
                subject = root.split('/')[1]
                file_name = root + "/" + file
                print("open file name: ", file_name)
                with open(file_name, encoding='utf-8', errors='ignore') as json_data:
                    data = json.load(json_data, strict=False)
                    print(data)
                    update_question(subject, data)

    for root, dirs, files in os.walk("Removed"):
        for file in files:
            if file.endswith(".json"):
                file_name = root + "/" + file
                print("open file name: ", file_name)
                with open(file_name, encoding='utf-8', errors='ignore') as json_data:
                    data = json.load(json_data, strict=False)
                    print(data)
                    removed_questions_answers(data)