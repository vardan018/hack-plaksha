import firebase_admin
from firebase_admin import credentials, storage
from pydub import AudioSegment
from pydub.playback import play
import os
import time  

# Initialize Firebase (do this only once at the top)
cred = credentials.Certificate("/Users/muditsurana13/Downloads/wavelength-4d2e8-firebase-adminsdk-y7grr-d3c885fde4.json") 
firebase_admin.initialize_app(cred, {
    'storageBucket': "wavelength-4d2e8.appspot.com" 
})

def layer_multiple_audio_with_vocal_boost(audio_files):
    """Layers multiple audio files, boosting the volume of files containing 'vocals' in their filename.

    Args:
        audio_files (list): A list of paths to the audio files.

    Returns:
        pydub.AudioSegment: The combined audio.
    """

    combined_sound = None
    for audio_file in audio_files:
        sound = AudioSegment.from_file(audio_file)

        # Increase volume for "vocals" files
        if "vocals" in audio_file.lower():  
            sound = sound + 6  

        if combined_sound is None:
            combined_sound = sound
        else:
            combined_sound = combined_sound.overlay(sound)

    return combined_sound

def download_from_firebase(firebase_bucket_name, source_path, destination_path):
    """Downloads a file from Firebase Storage."""

    bucket = storage.bucket()
    blob = bucket.blob(source_path)
    blob.download_to_filename(destination_path)

def upload_to_firebase(file_path, firebase_bucket_name, destination_folder):
    """Uploads a file to Firebase Storage."""

    filename = os.path.basename(file_path) 
    timestamp = str(int(time.time()))
    new_destination_path = os.path.join(destination_folder, f"{filename}_{timestamp}.mp3")

    bucket = storage.bucket()
    blob = bucket.blob(new_destination_path)
    blob.upload_from_filename(file_path)

def download_layer_and_upload(firebase_bucket_name, file_paths, destination_folder):
    """Downloads multiple files, layers them, and uploads the result.

    Args:
        firebase_bucket_name (str): The name of your Firebase Storage bucket.
        file_paths (list): List of paths to files in Firebase Storage.
        destination_folder (str): Base folder for the upload in Firebase Storage.
    """

    # 1. Download files
    local_files = []
    for source_path in file_paths:
        _, filename = os.path.split(source_path)
        local_path = os.path.join('/tmp/', filename)  
        download_from_firebase(firebase_bucket_name, source_path, local_path)
        local_files.append(local_path)

    # 2. Layer audio 
    layered_audio = layer_multiple_audio_with_vocal_boost(local_files)
    layered_audio.export("layered_output.mp3", format="mp3") 

    # 3. Upload
    upload_to_firebase("layered_output.mp3", firebase_bucket_name, destination_folder) 

# Example Usage
files_to_download = [
    "audio/layered_output.mp3",
    "audio/layered_output.mp3_1708857424.mp3"
]
download_layer_and_upload("wavelength-4d2e8.appspot.com", files_to_download, "audio")
