

import glob, os
import json
from google.cloud import firestore
import hashlib


def upload_data(data):
    db = firestore.Client()

    choices = data['choices']
    question = data['question']
    tags = data['tags']

    hash_key = hashlib.sha256()
    hash_key.update(data['question']['text'].encode('utf-8'))
    hash_key.update(''.join(data['tags']).encode('utf-8'))
    hash_key.update(''.join([c['answer'] for c in data['choices']]).encode('utf-8'))

    doc_ref = db.collection('build_up').document(hash_key.hexdigest())
    doc_ref.set({
        'question': question,
        'choice': choices,
        'tags': tags
    })


if __name__ == '__main__':
    for root, dirs, files in os.walk("Staging"):

        for file in files:
            if file.endswith(".json"):
                file_name = root + "/" + file
                print("open file name: ", file_name)
                with open(file_name, encoding='utf-8', errors='ignore') as json_data:
                    data = json.load(json_data, strict=False)
                    print(data)
                    upload_data(data)