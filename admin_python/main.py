
import glob, os
import json
from google.cloud import firestore
import hashlib

build_up_collection_name = 'build_up'

def update_tags(data):
    db = firestore.Client()

    collectionId = data['collectionId']
    title = data['title']
    thumbnail = data['thumbnail']

    doc_ref = db.collection("tags").document(collectionId)

    doc_ref.set({
        'collectionId': collectionId,
        'title': title,
        'thumbnail': thumbnail
    })

def update_question(data):
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
        'docId': docId,
        'question': question,
        'choices': choices,
        'tags': tags
    })


if __name__ == '__main__':

    for root, dirs, files in os.walk("Tag"):
        for file in files:
            if file.endswith(".json"):
                file_name = root + "/" + file
                print("open file name: ", file_name)
                with open(file_name, encoding='utf-8', errors='ignore') as json_data:
                    data = json.load(json_data, strict=False)
                    print(data)
                    update_tags(data)

    for root, dirs, files in os.walk("Staging"):
        for file in files:
            if file.endswith(".json"):
                file_name = root + "/" + file
                print("open file name: ", file_name)
                with open(file_name, encoding='utf-8', errors='ignore') as json_data:
                    data = json.load(json_data, strict=False)
                    print(data)
                    update_question(data)
